import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../l10n/app_localizations.dart';
import '../models/child.dart';
import '../models/vaccination_record.dart';
import '../models/vaccine.dart';
import '../utils/schedule_utils.dart';
import '../utils/vaccine_localizer.dart';

class PdfService {
  static Future<void> generateVaccinationReport({
    required Child child,
    required List<Vaccine> vaccines,
    required List<int> doneIds,
    required Map<int, String?> doneDates,
    required AppLocalizations loc,
    required String title,
    required String passportTitle,
    required String healthSectionTitle,
    required String doctorSignatureLabel,
    required String qrCodeLabel,
    required String childNameLabel,
    required String birthDateLabel,
    required String generatedLabel,
    required String vaccineLabel,
    required String recommendedLabel,
    required String statusLabel,
    required String doneAtLabel,
    required String completedLabel,
    required String overdueLabel,
    required String upcomingLabel,
  }) async {
    final regularFontData =
        await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final boldFontData =
        await rootBundle.load('assets/fonts/Roboto-Bold.ttf');

    final regularTtf = pw.Font.ttf(regularFontData);
    final boldTtf = pw.Font.ttf(boldFontData);

    final pdf = pw.Document(
      theme: pw.ThemeData.withFont(
        base: regularTtf,
        bold: boldTtf,
      ),
    );

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final history = doneDates.entries
        .map((entry) {
          final parsed =
              entry.value == null ? null : DateTime.tryParse(entry.value!);
          if (parsed == null) return null;

          return VaccinationRecord(
            id: 0,
            vaccineId: entry.key,
            vaccineKey: '',
            doneAt: parsed,
          );
        })
        .whereType<VaccinationRecord>()
        .toList();
    final recommendedDates = buildSmartSchedule(
      birthDate: child.birthDate,
      vaccines: vaccines,
      history: history,
    );

    final qrPayload = _buildQrPayload(
      child: child,
      generatedAt: now,
      doneCount: doneIds.length,
      totalCount: vaccines.length,
      loc: loc,
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.all(28),
        ),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      passportTitle,
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text('$childNameLabel: ${child.name}'),
                    pw.SizedBox(height: 4),
                    pw.Text('$birthDateLabel: ${_formatDate(child.birthDate)}'),
                    pw.SizedBox(height: 4),
                    pw.Text('$generatedLabel: ${_formatDate(now)}'),
                  ],
                ),
              ),
              pw.SizedBox(width: 16),
              pw.Column(
                children: [
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: qrPayload,
                    width: 72,
                    height: 72,
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    qrCodeLabel,
                    style: const pw.TextStyle(fontSize: 9),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 8),
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                top: pw.BorderSide(color: PdfColors.grey500),
                bottom: pw.BorderSide(color: PdfColors.grey500),
              ),
            ),
            child: pw.Text(
              title,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          pw.SizedBox(height: 12),
          ...vaccines.map(
            (vaccine) => _buildVaccineRow(
              vaccine: vaccine,
              recommendedDate: recommendedDates[vaccine.id] ??
                  calculateBaseRecommendedDate(
                    child.birthDate,
                    vaccine.ageInMonths,
                  ),
              doneAt: doneDates[vaccine.id],
              isDone: doneIds.contains(vaccine.id),
              today: today,
              loc: loc,
              completedLabel: completedLabel,
              overdueLabel: overdueLabel,
              upcomingLabel: upcomingLabel,
              vaccineLabel: vaccineLabel,
              statusLabel: statusLabel,
              recommendedLabel: recommendedLabel,
              doneAtLabel: doneAtLabel,
            ),
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            healthSectionTitle,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),
          _buildHealthRow(loc.allergies, child.allergies, loc),
          _buildHealthRow(loc.chronicDiseases, child.chronicDiseases, loc),
          _buildHealthRow(
            loc.medicalExemption,
            child.medicalExemptionUntil == null
                ? null
                : _formatDate(child.medicalExemptionUntil!),
            loc,
          ),
          _buildHealthRow(loc.notes, child.notes, loc),
          pw.SizedBox(height: 28),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                doctorSignatureLabel,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: pw.Container(
                  height: 1,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  static pw.Widget _buildVaccineRow({
    required Vaccine vaccine,
    required DateTime recommendedDate,
    required String? doneAt,
    required bool isDone,
    required DateTime today,
    required AppLocalizations loc,
    required String completedLabel,
    required String overdueLabel,
    required String upcomingLabel,
    required String vaccineLabel,
    required String statusLabel,
    required String recommendedLabel,
    required String doneAtLabel,
  }) {
    final status = isDone
        ? completedLabel
        : recommendedDate.isBefore(today)
            ? overdueLabel
            : upcomingLabel;

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            '${VaccineLocalizer.translate(loc, vaccine.key)} - $status',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text('$recommendedLabel: ${_formatDate(recommendedDate)}'),
          pw.Text('$doneAtLabel: ${_formatDoneDate(doneAt)}'),
        ],
      ),
    );
  }

  static pw.Widget _buildHealthRow(
    String label,
    String? value,
    AppLocalizations loc,
  ) {
    final resolved = value?.trim().isNotEmpty == true ? value!.trim() : loc.noData;
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.RichText(
        text: pw.TextSpan(
          style: const pw.TextStyle(fontSize: 11),
          children: [
            pw.TextSpan(
              text: '$label: ',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.TextSpan(text: resolved),
          ],
        ),
      ),
    );
  }

  static String _buildQrPayload({
    required Child child,
    required DateTime generatedAt,
    required int doneCount,
    required int totalCount,
    required AppLocalizations loc,
  }) {
    return [
      loc.pdfPassportTitle,
      '${loc.pdfChildName}: ${child.name}',
      '${loc.pdfBirthDate}: ${_formatDate(child.birthDate)}',
      '${loc.pdfGenerated}: ${_formatDate(generatedAt)}',
      '${loc.pdfCompleted}: $doneCount/$totalCount',
    ].join('\n');
  }

  static String _formatDate(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}.'
        '${value.month.toString().padLeft(2, '0')}.'
        '${value.year}';
  }

  static String _formatDoneDate(String? value) {
    if (value == null || value.isEmpty) return '-';
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return value;
    return _formatDate(parsed);
  }
}
