class Child {
  final int? id;
  final String name;
  final DateTime birthDate;
  final int? parentId;
  final DateTime? medicalExemptionUntil;
  final String? allergies;
  final String? chronicDiseases;
  final String? notes;
  final bool showRecommended;
  final bool showOptional;

  Child({
    this.id,
    required this.name,
    required this.birthDate,
    this.parentId,
    this.medicalExemptionUntil,
    this.allergies,
    this.chronicDiseases,
    this.notes,
    this.showRecommended = false,
    this.showOptional = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'birthDate': birthDate.toIso8601String(),
      'parentId': parentId,
      'medicalExemptionUntil': medicalExemptionUntil?.toIso8601String(),
      'allergies': allergies,
      'chronicDiseases': chronicDiseases,
      'notes': notes,
      'showRecommended': showRecommended ? 1 : 0,
      'showOptional': showOptional ? 1 : 0,
    };
  }

  factory Child.fromMap(Map<String, dynamic> map) {
    return Child(
      id: map['id'],
      name: map['name'],
      birthDate: DateTime.parse(map['birthDate']),
      parentId: map['parentId'] as int?,
      medicalExemptionUntil: map['medicalExemptionUntil'] != null
          ? DateTime.parse(map['medicalExemptionUntil'])
          : null,
      allergies: map['allergies'] as String?,
      chronicDiseases: map['chronicDiseases'] as String?,
      notes: map['notes'] as String?,
      showRecommended: (map['showRecommended'] ?? 0) == 1,
      showOptional: (map['showOptional'] ?? 0) == 1,
    );
  }
}
