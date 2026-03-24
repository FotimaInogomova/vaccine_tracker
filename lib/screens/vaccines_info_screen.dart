import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../models/vaccine.dart';
import '../utils/vaccine_localizer.dart';
import 'vaccine_info_screen.dart';

class VaccinesInfoScreen extends StatelessWidget {
  const VaccinesInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).padding.bottom + 80;

    return Scaffold(
      appBar: AppBar(title: Text(loc.vaccinesInfoTitle)),
      body: FutureBuilder<List<Vaccine>>(
        future: DatabaseHelper.instance.getVaccines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text(loc.vaccinesLoadingError));
          }

          final vaccines = snapshot.data!;
          final national = vaccines.where((v) => v.type == 'national').toList();
          final recommended = vaccines
              .where((v) => v.type == 'recommended')
              .toList();
          final optional = vaccines.where((v) => v.type == 'optional').toList();

          if (vaccines.isEmpty) {
            return _buildEmptyState(context, loc);
          }

          return ListView(
            padding: EdgeInsets.fromLTRB(24, 24, 24, bottomInset),
            children: [
              if (national.isNotEmpty) ...[
                _buildSectionTitle(loc.nationalVaccines),
                ...national.map((v) => _buildVaccineCard(context, v, loc)),
                const SizedBox(height: 20),
              ],
              if (recommended.isNotEmpty) ...[
                _buildSectionTitle(loc.recommendedVaccines),
                ...recommended.map((v) => _buildVaccineCard(context, v, loc)),
                const SizedBox(height: 20),
              ],
              if (optional.isNotEmpty) ...[
                _buildSectionTitle(loc.optionalVaccines),
                ...optional.map((v) => _buildVaccineCard(context, v, loc)),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildVaccineCard(
    BuildContext context,
    Vaccine vaccine,
    AppLocalizations loc,
  ) {
    final theme = Theme.of(context);
    final translated = VaccineLocalizer.name(loc, vaccine.key);
    final disease = VaccineLocalizer.disease(loc, vaccine.key);
    final title = translated == vaccine.key ? vaccine.name : translated;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VaccineInfoScreen(vaccine: vaccine),
              ),
            );
          },
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _infoRow(
                  context,
                  Icons.shield_outlined,
                  loc.protectsAgainst,
                  disease,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildMetaChip(
                      context,
                      icon: Icons.event_available_outlined,
                      label:
                          '${loc.recommendedAge}: ${vaccine.ageInMonths} ${loc.months}',
                    ),
                    _buildMetaChip(
                      context,
                      icon: Icons.category_outlined,
                      label: _typeLabel(loc, vaccine.type),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetaChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
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

  Widget _infoRow(
    BuildContext context,
    IconData icon,
    String title,
    String text, {
    Color? iconColor,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: iconColor ?? theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: text),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations loc) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.vaccines_outlined,
              size: 80,
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 16),
            Text(
              loc.emptyVaccinesTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              loc.emptyVaccinesSubtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
