import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/vaccine.dart';
import '../utils/vaccine_localizer.dart';

class VaccineInfoScreen extends StatelessWidget {
  final Vaccine vaccine;

  const VaccineInfoScreen({super.key, required this.vaccine});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final name = VaccineLocalizer.translate(loc, vaccine.key);
    final disease = VaccineLocalizer.disease(loc, vaccine.key);
    final description = VaccineLocalizer.description(loc, vaccine.key);
    final reactions = VaccineLocalizer.reactions(loc, vaccine.key);
    final contraindications =
        vaccine.contraindications?.trim().isNotEmpty == true
        ? vaccine.contraindications!.trim()
        : VaccineLocalizer.contraindications(loc, vaccine.key);

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCard(
            icon: Icons.coronavirus,
            title: loc.protectsAgainst,
            text: disease,
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.description,
            title: loc.description,
            text: description,
          ),
          const SizedBox(height: 16),
          _buildCard(
            icon: Icons.warning_amber,
            title: loc.reactions,
            text: reactions,
          ),
          if (contraindications.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildCard(
              icon: Icons.warning_amber_rounded,
              iconColor: Colors.orange,
              title: VaccineLocalizer.contraindicationsTitle(loc),
              text: contraindications,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String text,
    Color? iconColor,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 28, color: iconColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(text.isEmpty ? '-' : text),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
