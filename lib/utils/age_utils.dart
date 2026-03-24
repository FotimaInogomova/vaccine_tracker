import '../l10n/app_localizations.dart';

int calculateAgeInMonths(DateTime birthDate, {DateTime? referenceDate}) {
  final now = referenceDate ?? DateTime.now();
  int months =
      (now.year - birthDate.year) * 12 + (now.month - birthDate.month);

  if (now.day < birthDate.day) {
    months--;
  }

  return months;
}

String formatAge(
  AppLocalizations loc,
  DateTime birthDate, {
  DateTime? referenceDate,
}) {
  final months = calculateAgeInMonths(
    birthDate,
    referenceDate: referenceDate,
  );

  if (months < 12) {
    return loc.ageMonthsFormat(months);
  }

  final years = months ~/ 12;
  final remainingMonths = months % 12;

  if (remainingMonths == 0) {
    return loc.ageYearsFormat(years);
  }

  return loc.ageYearsMonthsFormat(years, remainingMonths);
}

DateTime calculateRecommendedDate(
  DateTime birthDate,
  int ageInMonths,
) {
  return DateTime(
    birthDate.year,
    birthDate.month + ageInMonths,
    birthDate.day,
  );
}
