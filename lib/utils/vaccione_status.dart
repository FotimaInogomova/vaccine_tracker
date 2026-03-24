import 'package:flutter/material.dart';

enum VaccineStatus {
  done,
  upcoming,
  overdue,
  scheduled,
}

VaccineStatus getVaccineStatus({
  required int childAgeInMonths,
  required int vaccineAgeInMonths,
  required bool isDone,
}) {
  if (isDone) return VaccineStatus.done;

  final difference = vaccineAgeInMonths - childAgeInMonths;

  if (difference < 0) {
    return VaccineStatus.overdue;
  }

  if (difference <= 1) {
    return VaccineStatus.upcoming;
  }

  return VaccineStatus.scheduled;
}

Color vaccineStatusColor(BuildContext context, VaccineStatus status) {
  final scheme = Theme.of(context).colorScheme;

  switch (status) {
    case VaccineStatus.done:
      return scheme.primary;
    case VaccineStatus.upcoming:
      return const Color(0xFFF2B880);
    case VaccineStatus.overdue:
      return const Color(0xFFE6A4A4);
    case VaccineStatus.scheduled:
      return scheme.secondary;
  }
}
