import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../models/child.dart';
import '../models/vaccine.dart';
import '../services/auth_service.dart';
import '../utils/schedule_utils.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final Set<String> _selectedTypes = {'national', 'recommended', 'optional'};

  List<_ChildAnalyticsSource> _sources = [];
  List<_ChildAnalyticsSummary> _childAnalytics = [];

  int totalChildren = 0;
  int totalVaccines = 0;
  int completed = 0;
  int overdue = 0;
  int pending = 0;

  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final parent = await AuthService.instance.getCurrentParent();
    final parentId = parent?['id'] as int?;

    if (parentId == null) {
      if (!mounted) return;
      setState(() {
        _sources = [];
        _childAnalytics = [];
        totalChildren = 0;
        totalVaccines = 0;
        completed = 0;
        overdue = 0;
        pending = 0;
        loading = false;
      });
      return;
    }

    final children = await DatabaseHelper.instance.getChildrenByParent(parentId);
    final vaccines = await DatabaseHelper.instance.getVaccines();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sources = <_ChildAnalyticsSource>[];

    for (final child in children) {
      if (child.id == null) continue;

      final doneIds = (await DatabaseHelper.instance.getDoneVaccineIds(child.id!))
          .toSet();
      final recommendedDates = await calculateRecommendedDatesForChild(
        child: child,
        vaccines: vaccines,
      );

      final statuses = <_TrackedVaccineStatus>[];

      for (final vaccine in vaccines) {
        if (!_isTrackedForChild(child, vaccine)) continue;

        final recommendedDate = recommendedDates[vaccine.id] ??
            calculateBaseRecommendedDate(
              child.birthDate,
              vaccine.ageInMonths,
            );

        final isDone = doneIds.contains(vaccine.id);
        statuses.add(
          _TrackedVaccineStatus(
            vaccine: vaccine,
            isDone: isDone,
            isOverdue: !isDone && recommendedDate.isBefore(today),
          ),
        );
      }

      sources.add(
        _ChildAnalyticsSource(
          child: child,
          statuses: statuses,
        ),
      );
    }

    final aggregate = _buildAggregate(sources);

    if (!mounted) return;
    setState(() {
      _sources = sources;
      _childAnalytics = aggregate.childAnalytics;
      totalChildren = children.length;
      totalVaccines = aggregate.totalVaccines;
      completed = aggregate.completed;
      overdue = aggregate.overdue;
      pending = aggregate.pending;
      loading = false;
    });
  }

  bool _isTrackedForChild(Child child, Vaccine vaccine) {
    if (vaccine.type == 'national') return true;
    if (vaccine.type == 'recommended') return child.showRecommended;
    if (vaccine.type == 'optional') return child.showOptional;
    return false;
  }

  _StatisticsAggregate _buildAggregate(
    List<_ChildAnalyticsSource> sources,
  ) {
    final childAnalytics = sources
        .map((source) {
          final visibleStatuses = source.statuses
              .where((status) => _selectedTypes.contains(status.vaccine.type))
              .toList();
          final total = visibleStatuses.length;
          final completedCount = visibleStatuses.where((item) => item.isDone).length;
          final overdueCount = visibleStatuses.where((item) => item.isOverdue).length;
          final pendingCount = (total - completedCount - overdueCount)
              .clamp(0, total)
              .toInt();

          return _ChildAnalyticsSummary(
            child: source.child,
            total: total,
            completed: completedCount,
            overdue: overdueCount,
            pending: pendingCount,
          );
        })
        .where((summary) => summary.total > 0)
        .toList()
      ..sort(
        (a, b) => a.child.name.toLowerCase().compareTo(b.child.name.toLowerCase()),
      );

    final totalVaccines = childAnalytics.fold<int>(
      0,
      (sum, item) => sum + item.total,
    );
    final completed = childAnalytics.fold<int>(
      0,
      (sum, item) => sum + item.completed,
    );
    final overdue = childAnalytics.fold<int>(
      0,
      (sum, item) => sum + item.overdue,
    );
    final pending = childAnalytics.fold<int>(
      0,
      (sum, item) => sum + item.pending,
    );

    return _StatisticsAggregate(
      totalVaccines: totalVaccines,
      completed: completed,
      overdue: overdue,
      pending: pending,
      childAnalytics: childAnalytics,
    );
  }

  void _toggleType(String type) {
    if (_selectedTypes.contains(type) && _selectedTypes.length == 1) {
      return;
    }

    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }

      final aggregate = _buildAggregate(_sources);
      _childAnalytics = aggregate.childAnalytics;
      totalVaccines = aggregate.totalVaccines;
      completed = aggregate.completed;
      overdue = aggregate.overdue;
      pending = aggregate.pending;
    });
  }

  String _typeLabel(AppLocalizations loc, String type) {
    switch (type) {
      case 'recommended':
        return loc.recommendedVaccines;
      case 'optional':
        return loc.optionalVaccines;
      case 'national':
      default:
        return loc.nationalVaccines;
    }
  }

  Widget _statCard(String title, int value, Color accent) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        border: Border.all(color: accent.withOpacity(0.18)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(
            value.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  Widget _buildProtectionRing({
    required double percent,
    required double size,
    double strokeWidth = 10,
  }) {
    final clamped = percent.clamp(0.0, 1.0).toDouble();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              color: Colors.grey.withOpacity(0.14),
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: clamped,
              strokeWidth: strokeWidth,
              color: Colors.green,
            ),
          ),
          Text(
            '${(clamped * 100).round()}%',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedBar({
    required int completed,
    required int pending,
    required int overdue,
    double height = 12,
  }) {
    final total = completed + pending + overdue;
    if (total <= 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(height),
        child: Container(
          height: height,
          color: Colors.grey.withOpacity(0.12),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        height: height,
        child: Row(
          children: [
            if (completed > 0)
              Expanded(
                flex: completed,
                child: Container(color: Colors.green),
              ),
            if (pending > 0)
              Expanded(
                flex: pending,
                child: Container(color: Colors.blue),
              ),
            if (overdue > 0)
              Expanded(
                flex: overdue,
                child: Container(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricChip(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildProtectionCard(AppLocalizations loc, ThemeData theme) {
    final protectionRate = totalVaccines == 0 ? 0.0 : completed / totalVaccines;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          _buildProtectionRing(percent: protectionRate, size: 104),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.protectionLevel,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${completed.toString()} ${loc.ofText} ${totalVaccines.toString()}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                _buildSegmentedBar(
                  completed: completed,
                  pending: pending,
                  overdue: overdue,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 14,
                  runSpacing: 8,
                  children: [
                    _legendItem(Colors.green, loc.completed),
                    _legendItem(Colors.blue, loc.upcoming),
                    _legendItem(Colors.red, loc.overdue),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(AppLocalizations loc, ThemeData theme) {
    const orderedTypes = ['national', 'recommended', 'optional'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.vaccineFilters,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: orderedTypes.map((type) {
            return FilterChip(
              label: Text(_typeLabel(loc, type)),
              selected: _selectedTypes.contains(type),
              onSelected: (_) => _toggleType(type),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChildCard(
    BuildContext context,
    AppLocalizations loc,
    _ChildAnalyticsSummary analytics,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      analytics.child.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${loc.birthDate}: ${_formatDate(analytics.child.birthDate)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              _buildProtectionRing(
                percent: analytics.protectionRate,
                size: 76,
                strokeWidth: 8,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSegmentedBar(
            completed: analytics.completed,
            pending: analytics.pending,
            overdue: analytics.overdue,
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildMetricChip(
                loc.totalVaccinations,
                analytics.total,
                theme.colorScheme.primary,
              ),
              _buildMetricChip(loc.completed, analytics.completed, Colors.green),
              _buildMetricChip(loc.upcoming, analytics.pending, Colors.blue),
              _buildMetricChip(loc.overdue, analytics.overdue, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day.$month.${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(loc.statistics),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final bottomInset = MediaQuery.of(context).padding.bottom + 80;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.statistics),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFilterSection(loc, theme),
            const SizedBox(height: 20),
            _buildProtectionCard(loc, theme),
            const SizedBox(height: 20),
            _statCard(loc.totalChildren, totalChildren, theme.colorScheme.primary),
            _statCard(loc.totalVaccinations, totalVaccines, theme.colorScheme.primary),
            _statCard(loc.completed, completed, Colors.green),
            _statCard(loc.overdue, overdue, Colors.red),
            _statCard(loc.upcoming, pending, Colors.blue),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
              child: totalVaccines == 0
                  ? Center(child: Text(loc.noData))
                  : PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            value: completed.toDouble(),
                            color: Colors.green,
                            title: completed == 0 ? '' : completed.toString(),
                            radius: 60,
                          ),
                          PieChartSectionData(
                            value: pending.toDouble(),
                            color: Colors.blue,
                            title: pending == 0 ? '' : pending.toString(),
                            radius: 60,
                          ),
                          PieChartSectionData(
                            value: overdue.toDouble(),
                            color: Colors.red,
                            title: overdue == 0 ? '' : overdue.toString(),
                            radius: 60,
                          ),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _legendItem(Colors.green, loc.completed),
                _legendItem(Colors.blue, loc.upcoming),
                _legendItem(Colors.red, loc.overdue),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              loc.childAnalytics,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            if (_childAnalytics.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(loc.noData),
              )
            else
              ..._childAnalytics.map(
                (analytics) => _buildChildCard(context, loc, analytics),
              ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsAggregate {
  final int totalVaccines;
  final int completed;
  final int overdue;
  final int pending;
  final List<_ChildAnalyticsSummary> childAnalytics;

  const _StatisticsAggregate({
    required this.totalVaccines,
    required this.completed,
    required this.overdue,
    required this.pending,
    required this.childAnalytics,
  });
}

class _ChildAnalyticsSource {
  final Child child;
  final List<_TrackedVaccineStatus> statuses;

  const _ChildAnalyticsSource({
    required this.child,
    required this.statuses,
  });
}

class _TrackedVaccineStatus {
  final Vaccine vaccine;
  final bool isDone;
  final bool isOverdue;

  const _TrackedVaccineStatus({
    required this.vaccine,
    required this.isDone,
    required this.isOverdue,
  });
}

class _ChildAnalyticsSummary {
  final Child child;
  final int total;
  final int completed;
  final int overdue;
  final int pending;

  const _ChildAnalyticsSummary({
    required this.child,
    required this.total,
    required this.completed,
    required this.overdue,
    required this.pending,
  });

  double get protectionRate => total == 0 ? 0 : completed / total;
}
