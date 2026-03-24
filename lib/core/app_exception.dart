class AppValidationException implements Exception {
  const AppValidationException(this.code);

  final String code;

  @override
  String toString() => code;
}

abstract final class ValidationErrorCode {
  static const invalidData = 'invalidData';
  static const dateCannotBeInFuture = 'dateCannotBeInFuture';
  static const vaccinationDateTooEarly = 'vaccinationDateTooEarly';
  static const medicalExemptionActive = 'medicalExemptionActive';
  static const minimumIntervalNotMet = 'minimumIntervalNotMet';
}
