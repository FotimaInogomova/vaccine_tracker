class VaccinationRecord {
  final int id;
  final int vaccineId;
  final String vaccineKey;
  final DateTime doneAt;

  VaccinationRecord({
    required this.id,
    required this.vaccineId,
    required this.vaccineKey,
    required this.doneAt,
  });

  factory VaccinationRecord.fromMap(Map<String, dynamic> map) {
    return VaccinationRecord(
      id: map['id'],
      vaccineId: map['vaccine_id'],
      vaccineKey: map['vaccineKey'] ?? map['vaccine_key'] ?? '',
      doneAt: DateTime.parse(map['date'] ?? map['doneAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vaccine_id': vaccineId,
      'vaccineKey': vaccineKey,
      'date': doneAt.toIso8601String(),
    };
  }
}
