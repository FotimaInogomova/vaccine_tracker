import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../models/child.dart';
import '../models/vaccine.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';
import '../utils/age_utils.dart';
import '../utils/app_error_localizer.dart';
import '../utils/app_routes.dart';
import '../utils/schedule_utils.dart';
import '../utils/vaccine_localizer.dart';
import 'add_child_screen.dart';
import 'child_details_screen.dart';

class ChildrenListScreen extends StatefulWidget {
  const ChildrenListScreen({super.key});

  @override
  State<ChildrenListScreen> createState() => _ChildrenListScreenState();
}

class _ChildrenListScreenState extends State<ChildrenListScreen> {
  List<Child> _children = [];

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    final parent = await AuthService.instance.getCurrentParent();
    if (parent == null) return;

    final parentId = parent['id'] as int;
    final children = await DatabaseHelper.instance.getChildrenByParent(
      parentId,
    );

    setState(() {
      _children = children;
    });
  }

  Future<void> _confirmAndMark(Child child, Vaccine vaccine) async {
    final childId = child.id;
    if (childId == null) return;

    final loc = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.confirmVaccinationTitle),
        content: Text(
          loc.confirmVaccinationMessage(
            VaccineLocalizer.translate(loc, vaccine.key),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.confirm),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!mounted) return;

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: child.birthDate,
      lastDate: DateTime.now(),
      helpText: loc.selectDate,
    );

    if (selectedDate == null) return;

    try {
      await DatabaseHelper.instance.markVaccineDone(
        childId: childId,
        vaccineId: vaccine.id,
        doneDate: selectedDate,
      );
      HapticFeedback.mediumImpact();
      await NotificationService.instance.cancelNotification(
        vaccine.id * 100 + childId,
      );
      await NotificationService.instance.cancelNotification(
        vaccine.id * 1000 + childId,
      );
      await NotificationService.instance.cancelNotification(
        vaccine.id * 10000 + childId,
      );
    } catch (e) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text(loc.warning),
          content: Text(localizeAppError(e, loc)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(loc.ok),
            ),
          ],
        ),
      );
      return;
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(loc.vaccineMarkedDone),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: loc.undo,
          onPressed: () async {
            await DatabaseHelper.instance.unmarkVaccine(
              childId: childId,
              vaccineId: vaccine.id,
            );

            if (!mounted) return;

            setState(() {});
          },
        ),
      ),
    );

    setState(() {});
  }

  Future<ChildStats> _buildChildStats(Child child) async {
    final childId = child.id;
    if (childId == null) {
      return const ChildStats(0, 0, 0, 0);
    }

    final vaccines = await DatabaseHelper.instance.getVaccines();
    final doneIds = await DatabaseHelper.instance.getDoneVaccineIds(childId);
    final doneSet = doneIds.toSet();
    final recommendedDates = await calculateRecommendedDatesForChild(
      child: child,
      vaccines: vaccines,
    );
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final soonThreshold = today.add(const Duration(days: 30));

    int overdueCount = 0;
    int soonCount = 0;

    for (final vaccine in vaccines) {
      if (doneSet.contains(vaccine.id)) {
        continue;
      }

      final recommendedDate = recommendedDates[vaccine.id] ??
          calculateBaseRecommendedDate(
            child.birthDate,
            vaccine.ageInMonths,
          );

      if (recommendedDate.isBefore(today)) {
        overdueCount++;
      } else if (!recommendedDate.isAfter(soonThreshold)) {
        soonCount++;
      }
    }

    return ChildStats(
      doneIds.length,
      vaccines.length,
      overdueCount,
      soonCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).padding.bottom + 80;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.children),
      ),
      body: _children.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.child_care_rounded,
                    size: 80,
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.noChildren,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.fromLTRB(24, 24, 24, bottomInset),
              itemCount: _children.length,
              itemBuilder: (context, index) {
                final child = _children[index];

                return FutureBuilder<ChildStats>(
                  future: _buildChildStats(child),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const SizedBox();
                    }

                    final stats = snapshot.data!;
                    return _buildChildCard(
                      child,
                      stats.done,
                      stats.total,
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            fadeSlideRoute(const AddChildScreen()),
          );

          if (result == true) {
            _loadChildren();
          }
        },
        icon: const Icon(Icons.add),
        label: Text(loc.addChild),
      ),
    );
  }

  String _calculateAgeText(DateTime birthDate) {
    final loc = AppLocalizations.of(context)!;
    return formatAge(loc, birthDate);
  }

  Widget _buildChildCard(
    Child child,
    int done,
    int total,
  ) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final progress = total == 0 ? 0.0 : done / total;
    final percent = (progress * 100).round();

    return Card(
      margin: const EdgeInsets.only(bottom: 18),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChildDetailsScreen(child: child)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.9),
                      theme.colorScheme.primaryContainer,
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    child.name.isNotEmpty ? child.name[0].toUpperCase() : '?',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _calculateAgeText(child.birthDate),
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: progress),
                        duration: const Duration(milliseconds: 600),
                        builder: (context, value, _) {
                          return LinearProgressIndicator(
                            value: value,
                            minHeight: 10,
                            backgroundColor: theme.colorScheme.primary.withOpacity(
                              0.08,
                            ),
                            color: theme.colorScheme.primary,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$percent% • $done/$total ${loc.completed}',
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<_NextVaccine?>(
                      future: _getNextVaccine(child),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data == null) {
                          return const SizedBox();
                        }

                        final next = snapshot.data!;
                        final loc = AppLocalizations.of(context)!;

                        final canMark = next.days <= 0;
                        String label;
                        Color color;

                        if (next.days < 0) {
                          label = loc.overdueByDays(next.days.abs());
                          color = const Color(0xFFE6A4A4);
                        } else if (next.days == 0) {
                          label = loc.dueToday;
                          color = const Color(0xFFF2B880);
                        } else {
                          label = loc.inDays(next.days);
                          color = theme.colorScheme.secondary;
                        }

                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${VaccineLocalizer.translate(loc, next.vaccine.key)} • $label',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: color,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check),
                              iconSize: 20,
                              color: color,
                              onPressed: canMark
                                  ? () async {
                                      await _confirmAndMark(child, next.vaccine);
                                    }
                                  : null,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 54,
                height: 54,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 5,
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ],
            ),
          ),
      ),
    );
  }
  Future<_NextVaccine?> _getNextVaccine(Child child) async {
    final childId = child.id;
    if (childId == null) return null;

    final vaccines = await DatabaseHelper.instance.getVaccines();
    final doneIds = await DatabaseHelper.instance.getDoneVaccineIds(childId);
    final recommendedDates = await calculateRecommendedDatesForChild(
      child: child,
      vaccines: vaccines,
    );
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    _NextVaccine? closest;

    for (final vaccine in vaccines) {
      if (doneIds.contains(vaccine.id)) continue;

      final dueDate = recommendedDates[vaccine.id] ??
          calculateBaseRecommendedDate(
            child.birthDate,
            vaccine.ageInMonths,
          );
      final normalizedDueDate = DateTime(
        dueDate.year,
        dueDate.month,
        dueDate.day,
      );
      final days = normalizedDueDate.difference(today).inDays;

      if (closest == null || days < closest.days) {
        closest = _NextVaccine(
          vaccine: vaccine,
          days: days,
        );
      }
    }

    return closest;
  }
}

class ChildStats {
  final int done;
  final int total;
  final int overdue;
  final int soon;

  const ChildStats(this.done, this.total, this.overdue, this.soon);
}

class _NextVaccine {
  final Vaccine vaccine;
  final int days;

  _NextVaccine({
    required this.vaccine,
    required this.days,
  });
}


