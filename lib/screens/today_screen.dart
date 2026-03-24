import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../models/child.dart';
import '../models/vaccine.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../utils/schedule_utils.dart';
import '../utils/vaccine_localizer.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  late Future<List<TodayItem>> _todayFuture;

  @override
  void initState() {
    super.initState();
    _todayFuture = _loadTodayVaccines();
  }

  Future<List<TodayItem>> _loadTodayVaccines() async {
    final result = await _loadTodayItems();
    await _sendSmartReminders(result);
    return result;
  }

  Future<void> _sendSmartReminders(List<TodayItem> items) async {
    for (final item in items) {
      final childId = item.child.id;
      if (childId == null) continue;

      await NotificationService.instance.maybeShowSmartReminder(
        childId: childId,
        childName: item.child.name,
        vaccineId: item.vaccine.id,
        vaccineKey: item.vaccine.key,
        daysUntilDue: item.diffDays,
      );
    }
  }

  Future<List<TodayItem>> _loadTodayItems() async {
    final parent = await AuthService.instance.getCurrentParent();
    if (parent == null) return [];

    final parentId = parent['id'] as int;

    final children = await DatabaseHelper.instance.getChildrenByParent(parentId);
    final vaccines = await DatabaseHelper.instance.getVaccines();

    List<TodayItem> items = [];

    for (final child in children) {
      final doneIds = await DatabaseHelper.instance.getDoneVaccineIds(child.id!);
      final recommendedDates = await calculateRecommendedDatesForChild(
        child: child,
        vaccines: vaccines,
      );

      for (final vaccine in vaccines) {
        if (doneIds.contains(vaccine.id)) {
          continue;
        }
        if (vaccine.type == 'recommended' && !child.showRecommended) {
          continue;
        }
        if (vaccine.type == 'optional' && !child.showOptional) {
          continue;
        }

        final recommendedDate = recommendedDates[vaccine.id] ??
            calculateBaseRecommendedDate(
              child.birthDate,
              vaccine.ageInMonths,
            );

        final childId = child.id!;
        final daysBefore = await NotificationService.instance.daysBefore();
        final soonId = vaccine.id * 100 + childId;
        final todayId = vaccine.id * 1000 + childId;
        await NotificationService.instance.scheduleUpcomingReminder(
          id: soonId,
          childName: child.name,
          vaccineKey: vaccine.key,
          daysBefore: daysBefore,
          date: recommendedDate.subtract(Duration(days: daysBefore)),
        );
        await NotificationService.instance.scheduleDueReminder(
          id: todayId,
          childName: child.name,
          vaccineKey: vaccine.key,
          date: recommendedDate,
        );

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final due = DateTime(
          recommendedDate.year,
          recommendedDate.month,
          recommendedDate.day,
        );
        final diff = due.difference(today).inDays;
        final status = getStatusCategory(recommendedDate);

        if (status == 'overdue') {
          await NotificationService.instance.scheduleOverdueReminders(
            childId: child.id!,
            vaccineId: vaccine.id,
            childName: child.name,
            vaccineKey: vaccine.key,
            dueDate: recommendedDate,
          );
        }

        items.add(
          TodayItem(
            child: child,
            vaccine: vaccine,
            status: status,
            recommendedDate: recommendedDate,
            diffDays: diff,
          ),
        );
      }
    }

    items.sort((a, b) {
      final aStatus = getStatusCategory(a.recommendedDate);
      final bStatus = getStatusCategory(b.recommendedDate);

      const order = {
        'overdue': 0,
        'today': 1,
        'soon': 2,
        'later': 3,
      };

      final byStatus = order[aStatus]!.compareTo(order[bStatus]!);
      if (byStatus != 0) return byStatus;
      return a.recommendedDate.compareTo(b.recommendedDate);
    });

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.today),
      ),
      body: FutureBuilder<List<TodayItem>>(
        future: _todayFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(loc.errorLoading),
            );
          }

          final items = snapshot.data ?? [];
          final overdue = items.where((i) => i.status == 'overdue').toList();
          final today = items.where((i) => i.status == 'today').toList();
          final soon = items.where((i) => i.status == 'soon').toList();
          final later = items.where((i) => i.status == 'later').toList();

          if (items.isEmpty) {
            return _buildEmptyState(loc);
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: _buildSummaryBar(
                  context,
                  overdue.length,
                  today.length,
                  soon.length,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final future = _loadTodayVaccines();
                    setState(() {
                      _todayFuture = future;
                    });
                    await future;
                  },
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      if (overdue.isNotEmpty) ...[
                        _buildSectionHeader(loc.overdue, Colors.red),
                        ...overdue.map((v) => _buildVaccineCard(v, loc)),
                      ],
                      if (today.isNotEmpty) ...[
                        _buildSectionHeader(loc.today, Colors.orange),
                        ...today.map((v) => _buildVaccineCard(v, loc)),
                      ],
                      if (soon.isNotEmpty) ...[
                        _buildSectionHeader(loc.soon, Colors.blue),
                        ...soon.map((v) => _buildVaccineCard(v, loc)),
                      ],
                      if (later.isNotEmpty) ...[
                        _buildSectionHeader(loc.later, Colors.grey),
                        ...later.map((v) => _buildVaccineCard(v, loc)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations loc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified,
              size: 60,
              color: Colors.green,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            loc.noVaccinesToday,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            loc.everythingUpToDate,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVaccineCard(TodayItem item, AppLocalizations loc) {
    final theme = Theme.of(context);
    final status = getStatusCategory(item.recommendedDate);
    final cardColor = getStatusColor(status, theme);
    final accentColor = _statusAccentColor(status);
    final label = getStatusText(status, loc);
    final daysText = _daysLabel(loc, item.diffDays);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Container(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 56,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            getStatusIcon(status),
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              VaccineLocalizer.translate(loc, item.vaccine.key),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.child.name,
                        style: TextStyle(
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${loc.recommendedDate}: '
                        '${item.recommendedDate.day.toString().padLeft(2, '0')}.'
                        '${item.recommendedDate.month.toString().padLeft(2, '0')}.'
                        '${item.recommendedDate.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        daysText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (label.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBar(
    BuildContext context,
    int overdue,
    int today,
    int soon,
  ) {
    final loc = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSummaryItem(
          color: Colors.red,
          label: loc.overdue,
          count: overdue,
        ),
        _buildSummaryItem(
          color: Colors.orange,
          label: loc.today,
          count: today,
        ),
        _buildSummaryItem(
          color: Colors.blue,
          label: loc.soon,
          count: soon,
        ),
      ],
    );
  }

  Widget _buildSummaryItem({
    required Color color,
    required String label,
    required int count,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getStatusCategory(DateTime dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);

    final diff = due.difference(today).inDays;

    if (diff < 0) return 'overdue';
    if (diff == 0) return 'today';
    if (diff <= 7) return 'soon';
    return 'later';
  }

  Color getStatusColor(String status, ThemeData theme) {
    switch (status) {
      case 'overdue':
        return Colors.red.shade100;
      case 'today':
        return Colors.orange.shade100;
      case 'soon':
        return Colors.blue.shade100;
      default:
        return theme.colorScheme.surfaceVariant;
    }
  }

  String getStatusText(String status, AppLocalizations loc) {
    switch (status) {
      case 'overdue':
        return loc.overdue;
      case 'today':
        return loc.today;
      case 'soon':
        return loc.soon;
      default:
        return '';
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case 'overdue':
        return Icons.warning_amber_rounded;
      case 'today':
        return Icons.today;
      case 'soon':
        return Icons.schedule;
      default:
        return Icons.check_circle_outline;
    }
  }

  Color _statusAccentColor(String status) {
    switch (status) {
      case 'overdue':
        return Colors.red.shade700;
      case 'today':
        return Colors.orange.shade700;
      case 'soon':
        return Colors.blue.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _daysLabel(
    AppLocalizations loc,
    int days,
  ) {
    if (days == 0) {
      return loc.dueNow;
    } else if (days > 0) {
      return loc.inDays(days);
    } else {
      return loc.overdueByDays(days.abs());
    }
  }

}

class TodayItem {
  final Child child;
  final Vaccine vaccine;
  final String status;
  final DateTime recommendedDate;
  final int diffDays;

  TodayItem({
    required this.child,
    required this.vaccine,
    required this.status,
    required this.recommendedDate,
    required this.diffDays,
  });
}



