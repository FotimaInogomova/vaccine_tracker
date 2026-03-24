import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vaccine_tracker/core/app_exception.dart';
import 'package:vaccine_tracker/l10n/app_localizations.dart';
import 'package:vaccine_tracker/models/vaccination_record.dart';
import 'package:vaccine_tracker/models/vaccine.dart';
import 'package:vaccine_tracker/utils/age_utils.dart';
import 'package:vaccine_tracker/utils/app_error_localizer.dart';
import 'package:vaccine_tracker/utils/schedule_utils.dart';

void main() {
  test('formatAge localizes age output for all supported languages', () {
    final birthDate = DateTime(2024, 1, 15);
    final referenceDate = DateTime(2026, 3, 14);

    expect(
      formatAge(
        lookupAppLocalizations(const Locale('en')),
        birthDate,
        referenceDate: referenceDate,
      ),
      '2 y 1 m',
    );

    expect(
      formatAge(
        lookupAppLocalizations(const Locale('ru')),
        birthDate,
        referenceDate: referenceDate,
      ),
      '2 г. 1 мес.',
    );

    expect(
      formatAge(
        lookupAppLocalizations(const Locale('uz')),
        birthDate,
        referenceDate: referenceDate,
      ),
      '2 yosh 1 oy',
    );
  });

  test('localizeAppError maps validation codes to localized text', () {
    final error = const AppValidationException(
      ValidationErrorCode.medicalExemptionActive,
    );

    expect(
      localizeAppError(error, lookupAppLocalizations(const Locale('en'))),
      'Medical exemption is active',
    );
    expect(
      localizeAppError(error, lookupAppLocalizations(const Locale('ru'))),
      'Медотвод активен',
    );
    expect(
      localizeAppError(error, lookupAppLocalizations(const Locale('uz'))),
      'Tibbiy cheklov faol',
    );
  });

  test('smart schedule shifts the whole vaccine series after a late first dose', () {
    final vaccines = [
      Vaccine(
        id: 1,
        name: 'DTP (1)',
        key: 'akds_1',
        ageInMonths: 2,
        type: 'national',
      ),
      Vaccine(
        id: 2,
        name: 'DTP (2)',
        key: 'akds_2',
        ageInMonths: 3,
        type: 'national',
        minIntervalMonths: 1,
      ),
      Vaccine(
        id: 3,
        name: 'DTP (3)',
        key: 'akds_3',
        ageInMonths: 4,
        type: 'national',
        minIntervalMonths: 1,
      ),
    ];
    final history = [
      VaccinationRecord(
        id: 10,
        vaccineId: 1,
        vaccineKey: 'akds_1',
        doneAt: DateTime(2024, 4, 1),
      ),
    ];

    final schedule = buildSmartSchedule(
      birthDate: DateTime(2024, 1, 1),
      vaccines: vaccines,
      history: history,
    );

    expect(schedule[1], DateTime(2024, 3, 1));
    expect(schedule[2], DateTime(2024, 5, 1));
    expect(schedule[3], DateTime(2024, 6, 1));
  });
}
