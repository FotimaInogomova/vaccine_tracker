import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../models/vaccination_record.dart';
import '../utils/app_error_localizer.dart';
import '../utils/vaccine_localizer.dart';

class VaccinationHistoryScreen extends StatefulWidget {
  final int childId;
  final DateTime childBirthDate;

  const VaccinationHistoryScreen({
    super.key,
    required this.childId,
    required this.childBirthDate,
  });

  @override
  State<VaccinationHistoryScreen> createState() => _VaccinationHistoryScreenState();
}

class _VaccinationHistoryScreenState extends State<VaccinationHistoryScreen> {
  Future<void> _editDate(VaccinationRecord record) async {
    final loc = AppLocalizations.of(context)!;
    final newDate = await showDatePicker(
      context: context,
      initialDate: record.doneAt,
      firstDate: widget.childBirthDate,
      lastDate: DateTime.now(),
      helpText: loc.selectDate,
    );

    if (newDate == null) return;

    try {
      await DatabaseHelper.instance.updateVaccinationDate(
        record.id,
        newDate,
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizeAppError(error, loc))),
      );
      return;
    }

    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Text(loc.vaccinationHistory),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          DatabaseHelper.instance.getVaccinationHistory(widget.childId),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(loc.failedToLoadData),
            );
          }

          final records = snapshot.data![0] as List<VaccinationRecord>;

          if (records.isEmpty) {
            return _buildEmptyHistory(context, loc);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final r = records[index];

              return GestureDetector(
                onTap: () => _editDate(r),
                child: _buildHistoryCard(
                  context,
                  r.vaccineKey,
                  r.doneAt,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    String vaccineKey,
    DateTime date,
  ) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 50,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  VaccineLocalizer.translate(loc, vaccineKey),
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}.${date.month}.${date.year}',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Color(0xFF43A047),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off,
            size: 60,
            color: theme.colorScheme.primary.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            loc.noHistory,
            style: theme.textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
