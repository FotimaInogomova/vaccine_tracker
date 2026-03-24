import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../models/child.dart';
import '../models/vaccine.dart';
import '../services/notification_service.dart';
import '../services/pdf_service.dart';
import '../utils/app_error_localizer.dart';
import '../utils/vaccine_localizer.dart';
import '../utils/schedule_utils.dart' as schedule_utils;
import 'vaccine_info_screen.dart';
import 'vaccination_history_screen.dart';

class ChildDetailsScreen extends StatefulWidget {
  final Child child;

  const ChildDetailsScreen({super.key, required this.child});

  @override
  State<ChildDetailsScreen> createState() => _ChildDetailsScreenState();
}

class _ChildDetailsScreenState extends State<ChildDetailsScreen> {
  late Child _child;
  List<Vaccine> _vaccines = [];
  List<int> _doneVaccineIds = [];
  Map<int, DateTime> _recommendedDates = {};
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late bool _showRecommended;
  late bool _showOptional;

  @override
  void initState() {
    super.initState();
    _child = widget.child;
    _showRecommended = _child.showRecommended;
    _showOptional = _child.showOptional;
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final latestChild = await DatabaseHelper.instance.getChildById(_child.id!);
    final vaccines = await DatabaseHelper.instance.getVaccines();
    final ids = await DatabaseHelper.instance.getDoneVaccineIds(_child.id!);
    final recommendedDates = await schedule_utils.calculateRecommendedDatesForChild(
      child: latestChild ?? _child,
      vaccines: vaccines,
    );

    if (!mounted) return;
    setState(() {
      _child = latestChild ?? _child;
      _showRecommended = _child.showRecommended;
      _showOptional = _child.showOptional;
      _vaccines = vaccines;
      _doneVaccineIds = ids;
      _recommendedDates = recommendedDates;
    });
  }

  Future<void> _updatePreference(
    bool showRecommended,
    bool showOptional,
  ) async {
    final childId = _child.id;
    if (childId == null) return;

    await DatabaseHelper.instance.updateVaccinePreferences(
      childId,
      showRecommended,
      showOptional,
    );

    if (!mounted) return;
    setState(() {
      _showRecommended = showRecommended;
      _showOptional = showOptional;
    });
  }

  Future<void> _setMedicalExemption() async {
    final loc = AppLocalizations.of(context)!;
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date == null) return;

    await DatabaseHelper.instance.updateMedicalExemption(
      _child.id!,
      date,
    );

    final vaccines = _vaccines.isNotEmpty
        ? _vaccines
        : await DatabaseHelper.instance.getVaccines();
    final doneIds = _doneVaccineIds.isNotEmpty
        ? _doneVaccineIds
        : await DatabaseHelper.instance.getDoneVaccineIds(_child.id!);
    final recommendedDates = _recommendedDates.isNotEmpty
        ? _recommendedDates
        : await schedule_utils.calculateRecommendedDatesForChild(
            child: _child,
            vaccines: vaccines,
          );

    for (final vaccine in vaccines) {
      if (doneIds.contains(vaccine.id)) continue;

      final recommendedDate = recommendedDates[vaccine.id] ??
          schedule_utils.calculateBaseRecommendedDate(
            _child.birthDate,
            vaccine.ageInMonths,
          );
      final recalculatedDate = recommendedDate.isBefore(date)
          ? date
          : recommendedDate;

      await NotificationService.instance.rescheduleAfterExemption(
        childId: _child.id!,
        vaccineId: vaccine.id,
        childName: _child.name,
        vaccineKey: vaccine.key,
        newDate: recalculatedDate,
      );
    }

    await _loadData();
  }

 Future<void> _editHealthCard() async {
  final loc = AppLocalizations.of(context)!;
  if (_child.id == null) return;

  final allergiesController =
      TextEditingController(text: _child.allergies ?? '');

  final chronicDiseasesController =
      TextEditingController(text: _child.chronicDiseases ?? '');

  final notesController =
      TextEditingController(text: _child.notes ?? '');

  final result = await showDialog<bool>(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: Text(loc.healthCard),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: allergiesController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: loc.allergies,
                  hintText: loc.enterAllergies,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: chronicDiseasesController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: loc.chronicDiseases,
                  hintText: loc.enterChronicDiseases,
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: loc.notes,
                  hintText: loc.enterNotes,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text(loc.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(loc.save),
          ),
        ],
      );
    },
  );

  if (result == true) {
    await DatabaseHelper.instance.updateChildHealthProfile(
      childId: _child.id!,
      allergies: allergiesController.text,
      chronicDiseases: chronicDiseasesController.text,
      notes: notesController.text,
    );

    await _loadData();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.healthCardSaved)),
    );
  }

  allergiesController.dispose();
  chronicDiseasesController.dispose();
  notesController.dispose();
}

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom + 80;

    final child = _child;
    final filteredVaccines = _vaccines.where((v) {
      final isAllowedByType =
          v.type == 'national' ||
          (v.type == 'recommended' && _showRecommended) ||
          (v.type == 'optional' && _showOptional);
      if (!isAllowedByType) return false;

      if (_searchQuery.isEmpty) return true;

      final translatedName =
          VaccineLocalizer.translate(loc, v.key).toLowerCase();
      return translatedName.contains(_searchQuery) ||
          v.key.toLowerCase().contains(_searchQuery);
    }).toList();
    final nationalVaccines =
        filteredVaccines.where((v) => v.type == 'national').toList();
    final recommendedVaccines =
        filteredVaccines.where((v) => v.type == 'recommended').toList();
    final optionalVaccines =
        filteredVaccines.where((v) => v.type == 'optional').toList();

    final total = filteredVaccines.length;
    final done = filteredVaccines
        .where((v) => _doneVaccineIds.contains(v.id))
        .length;
    final progress = total == 0 ? 0.0 : done / total;

    return Scaffold(
      body: _vaccines.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(child.name),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primaryContainer,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.child_care,
                          size: 80,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf),
                      onPressed: () async {
                        final history = await DatabaseHelper.instance
                            .getVaccinationHistory(child.id!);

                        final Map<int, String?> doneDatesMap = {
                          for (final record in history)
                            record.vaccineId: record.doneAt.toIso8601String(),
                        };

                        await PdfService.generateVaccinationReport(
                          child: child,
                          vaccines: _vaccines,
                          doneIds: _doneVaccineIds,
                          doneDates: doneDatesMap,
                          loc: loc,
                          title: loc.pdfTitle,
                          passportTitle: loc.pdfPassportTitle,
                          healthSectionTitle: loc.pdfHealthSection,
                          doctorSignatureLabel: loc.pdfDoctorSignature,
                          qrCodeLabel: loc.pdfQrCode,
                          childNameLabel: loc.pdfChildName,
                          birthDateLabel: loc.pdfBirthDate,
                          generatedLabel: loc.pdfGenerated,
                          vaccineLabel: loc.pdfVaccine,
                          recommendedLabel: loc.pdfRecommended,
                          statusLabel: loc.pdfStatus,
                          doneAtLabel: loc.pdfDoneAt,
                          completedLabel: loc.pdfCompleted,
                          overdueLabel: loc.pdfOverdue,
                          upcomingLabel: loc.pdfUpcoming,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.history),
                      tooltip: loc.history,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VaccinationHistoryScreen(
                              childId: _child.id!,
                              childBirthDate: _child.birthDate,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.medical_information_outlined),
                      tooltip: loc.editHealthCard,
                      onPressed: _editHealthCard,
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.vaccinationProgress,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$done ${loc.ofText} $total ${loc.completed}',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildHealthCard(loc),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: Text(loc.showRecommended),
                          value: _showRecommended,
                          onChanged: (val) async {
                            await _updatePreference(val, _showOptional);
                          },
                        ),
                        SwitchListTile(
                          title: Text(loc.showOptional),
                          value: _showOptional,
                          onChanged: (val) async {
                            await _updatePreference(_showRecommended, val);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      onPressed: _setMedicalExemption,
                      icon: const Icon(Icons.pause_circle),
                      label: Text(loc.setMedicalExemption),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: loc.searchVaccine,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.trim().toLowerCase();
                        });
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (nationalVaccines.isNotEmpty) ...[
                        _buildSectionHeader(loc.nationalVaccines),
                        ...nationalVaccines.map(
                          (v) => _buildVaccineTile(v, loc),
                        ),
                      ],
                      if (recommendedVaccines.isNotEmpty) ...[
                        _buildSectionHeader(loc.recommendedVaccines),
                        ...recommendedVaccines.map(
                          (v) => _buildVaccineTile(v, loc),
                        ),
                      ],
                      if (optionalVaccines.isNotEmpty) ...[
                        _buildSectionHeader(loc.optionalVaccines),
                        ...optionalVaccines.map(
                          (v) => _buildVaccineTile(v, loc),
                        ),
                      ],
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: bottomInset),
                ),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildHealthCard(AppLocalizations loc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    loc.healthCard,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _editHealthCard,
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: loc.editHealthCard,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _healthRow(loc.allergies, _child.allergies, loc),
            const SizedBox(height: 8),
            _healthRow(loc.chronicDiseases, _child.chronicDiseases, loc),
            const SizedBox(height: 8),
            _healthRow(
              loc.medicalExemption,
              _child.medicalExemptionUntil == null
                  ? null
                  : _formatDate(_child.medicalExemptionUntil!),
              loc,
            ),
            const SizedBox(height: 8),
            _healthRow(loc.notes, _child.notes, loc),
          ],
        ),
      ),
    );
  }

  Widget _healthRow(String label, String? value, AppLocalizations loc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 150,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ),
        Expanded(
          child: Text(value?.trim().isNotEmpty == true ? value!.trim() : loc.noData),
        ),
      ],
    );
  }

  String _formatDate(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}.'
        '${value.month.toString().padLeft(2, '0')}.'
        '${value.year}';
  }

  Widget _buildVaccineTile(
    Vaccine vaccine,
    AppLocalizations loc,
  ) {
    final isDone = _doneVaccineIds.contains(vaccine.id);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final recommendedDate = _recommendedDates[vaccine.id] ??
        schedule_utils.calculateBaseRecommendedDate(
          _child.birthDate,
          vaccine.ageInMonths,
        );
    final isTooEarly = recommendedDate.isAfter(today);

    String status;
    IconData icon;
    Color color;

    if (isDone) {
      status = loc.done;
      icon = Icons.check_circle;
      color = Colors.green;
    } else if (isTooEarly) {
      status = loc.tooEarly;
      icon = Icons.lock;
      color = Colors.grey;
    } else if (recommendedDate.isBefore(today)) {
      status = loc.overdue;
      icon = Icons.error;
      color = Colors.red;
    } else {
      status = loc.dueNow;
      icon = Icons.warning;
      color = Colors.orange;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          trailing: isDone
    ? const Icon(Icons.check_circle, color: Colors.green)
    : IconButton(
        icon: const Icon(Icons.check_circle_outline),
        color: color,
        onPressed: isTooEarly
            ? null
            : () async {

                if (_child.id == null) return;

                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: _child.birthDate,
                  lastDate: DateTime.now(),
                );

                if (selectedDate == null) return;

                await DatabaseHelper.instance.markVaccineDone(
                  childId: _child.id!,
                  vaccineId: vaccine.id,
                  doneDate: selectedDate,
                );

                await _loadData();
              },
      ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VaccineInfoScreen(
                  vaccine: vaccine,
                ),
              ),
            );
          },
          onLongPress: () async {
            if (!isDone || _child.id == null) return;

            final selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: _child.birthDate,
              lastDate: DateTime.now(),
              helpText: AppLocalizations.of(context)!.selectDate,
            );

            if (selectedDate == null) return;

            try {
              await DatabaseHelper.instance.updateVaccinationDate(
                vaccine.id,
                selectedDate,
                childId: _child.id!,
              );
            } catch (error) {
              if (!mounted) return;
              final loc = AppLocalizations.of(context)!;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localizeAppError(error, loc))),
              );
              return;
            }

            await _loadData();
          },
          contentPadding: const EdgeInsets.only(right: 16),
          title: Row(
            children: [
              Container(
                width: 6,
                height: 90,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(icon, color: color),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              VaccineLocalizer.translate(loc, vaccine.key),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${vaccine.ageInMonths} ${loc.months}',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${loc.recommendedDate}: '
                        '${recommendedDate.day.toString().padLeft(2, '0')}.'
                        '${recommendedDate.month.toString().padLeft(2, '0')}.'
                        '${recommendedDate.year}',
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        status,
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

