int calculateVaccineProgress({
  required int totalVaccines,
  required int doneVaccines,
}) {
  if (totalVaccines == 0) return 0;
  return ((doneVaccines / totalVaccines) * 100).round();
}
