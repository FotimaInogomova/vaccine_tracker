import '../core/app_exception.dart';
import '../l10n/app_localizations.dart';

String localizeAppError(Object error, AppLocalizations loc) {
  if (error is AppValidationException) {
    switch (error.code) {
      case ValidationErrorCode.invalidData:
        return loc.invalidData;
      case ValidationErrorCode.dateCannotBeInFuture:
        return loc.dateCannotBeInFuture;
      case ValidationErrorCode.vaccinationDateTooEarly:
        return loc.vaccinationDateTooEarly;
      case ValidationErrorCode.medicalExemptionActive:
        return loc.medicalExemptionActive;
      case ValidationErrorCode.minimumIntervalNotMet:
        return loc.intervalError;
    }
  }

  return loc.errorLoading;
}
