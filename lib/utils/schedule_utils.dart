import '../database/database_helper.dart';
import '../models/child.dart';
import '../models/vaccination_record.dart';
import '../models/vaccine.dart';

Map<int, DateTime> buildSmartSchedule({
  required DateTime birthDate,
  required List<Vaccine> vaccines,
  Iterable<VaccinationRecord> history = const [],
}) {
  final recommendedDates = <int, DateTime>{};
  final historyByVaccineId = {
    for (final record in history) record.vaccineId: record.doneAt,
  };

  final vaccinesBySeries = <String, List<Vaccine>>{};
  for (final vaccine in vaccines) {
    vaccinesBySeries.putIfAbsent(_seriesKey(vaccine), () => []).add(vaccine);
  }

  for (final series in vaccinesBySeries.values) {
    series.sort(_compareVaccinesInSeries);

    Vaccine? previousVaccine;
    DateTime? previousAnchorDate;

    for (final vaccine in series) {
      var recommendedDate = _baseRecommendedDate(
        birthDate: birthDate,
        ageInMonths: vaccine.ageInMonths,
      );

      if (previousVaccine != null && previousAnchorDate != null) {
        final intervalMonths = _intervalFromPrevious(
          previous: previousVaccine,
          current: vaccine,
        );
        final shiftedDate = _addMonths(previousAnchorDate, intervalMonths);
        if (shiftedDate.isAfter(recommendedDate)) {
          recommendedDate = shiftedDate;
        }
      }

      recommendedDates[vaccine.id] = recommendedDate;
      previousVaccine = vaccine;
      previousAnchorDate = historyByVaccineId[vaccine.id] ?? recommendedDate;
    }
  }

  return recommendedDates;
}

Future<Map<int, DateTime>> calculateRecommendedDatesForChild({
  required Child child,
  List<Vaccine>? vaccines,
  List<VaccinationRecord>? history,
}) async {
  final resolvedVaccines = vaccines ?? await DatabaseHelper.instance.getVaccines();
  final resolvedHistory = history ??
      (child.id == null
          ? const <VaccinationRecord>[]
          : await DatabaseHelper.instance.getVaccinationHistory(child.id!));

  return buildSmartSchedule(
    birthDate: child.birthDate,
    vaccines: resolvedVaccines,
    history: resolvedHistory,
  );
}

Future<DateTime> calculateRecommendedDate({
  required Child child,
  required Vaccine vaccine,
  List<Vaccine>? vaccines,
  List<VaccinationRecord>? history,
}) async {
  final recommendedDates = await calculateRecommendedDatesForChild(
    child: child,
    vaccines: vaccines,
    history: history,
  );

  return recommendedDates[vaccine.id] ??
      _baseRecommendedDate(
        birthDate: child.birthDate,
        ageInMonths: vaccine.ageInMonths,
      );
}

DateTime calculateBaseRecommendedDate(
  DateTime birthDate,
  int ageInMonths,
) {
  return _baseRecommendedDate(
    birthDate: birthDate,
    ageInMonths: ageInMonths,
  );
}

DateTime _baseRecommendedDate({
  required DateTime birthDate,
  required int ageInMonths,
}) {
  return DateTime(
    birthDate.year,
    birthDate.month + ageInMonths,
    birthDate.day,
  );
}

DateTime _addMonths(DateTime date, int months) {
  return DateTime(
    date.year,
    date.month + months,
    date.day,
  );
}

int _compareVaccinesInSeries(Vaccine a, Vaccine b) {
  final byAge = a.ageInMonths.compareTo(b.ageInMonths);
  if (byAge != 0) return byAge;

  final byDose = _seriesOrder(a).compareTo(_seriesOrder(b));
  if (byDose != 0) return byDose;

  return a.id.compareTo(b.id);
}

int _intervalFromPrevious({
  required Vaccine previous,
  required Vaccine current,
}) {
  final ageGap = current.ageInMonths - previous.ageInMonths;
  final minInterval = current.minIntervalMonths ?? 0;
  return ageGap > minInterval ? ageGap : minInterval;
}

String _seriesKey(Vaccine vaccine) {
  final keyMatch = RegExp(r'^(.*)_\d+$').firstMatch(vaccine.key);
  if (keyMatch != null) {
    return keyMatch.group(1)!.toLowerCase();
  }

  final nameMatch = RegExp(r'^(.*)\(\d+\)\s*$').firstMatch(vaccine.name);
  if (nameMatch != null) {
    return nameMatch.group(1)!.trim().toLowerCase();
  }

  return vaccine.key.toLowerCase();
}

int _seriesOrder(Vaccine vaccine) {
  final keyMatch = RegExp(r'_(\d+)$').firstMatch(vaccine.key);
  if (keyMatch != null) {
    return int.parse(keyMatch.group(1)!);
  }

  final nameMatch = RegExp(r'\((\d+)\)').firstMatch(vaccine.name);
  if (nameMatch != null) {
    return int.parse(nameMatch.group(1)!);
  }

  return 0;
}
