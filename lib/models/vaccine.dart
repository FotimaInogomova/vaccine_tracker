class Vaccine {
  final int id;
  final String name;
  final String key;
  final int ageInMonths;
  final String type;
  final int? minIntervalMonths;
  final String? contraindications;

  Vaccine({
    required this.id,
    required this.name,
    required this.key,
    required this.ageInMonths,
    required this.type,
    this.minIntervalMonths,
    this.contraindications,
  });

  factory Vaccine.fromMap(Map<String, dynamic> map) {
    return Vaccine(
      id: map['id'],
      name: map['name'],
      key: map['vaccineKey'] ?? _deriveKeyFromName(map['name']),
      ageInMonths: map['ageInMonths'],
      type: map['type'] ?? 'national',
      minIntervalMonths: map['minIntervalMonths'],
      contraindications: map['contraindications'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'vaccineKey': key,
      'ageInMonths': ageInMonths,
      'type': type,
      'minIntervalMonths': minIntervalMonths,
      'contraindications': contraindications,
    };
  }

  static String _deriveKeyFromName(dynamic rawName) {
    final name = (rawName ?? '').toString().toLowerCase().trim();
    if (name == 'bcg' || name == 'бцж') return 'bcg';
    if (name.contains('hepatitis b (1)') || name.contains('гепатит b (1)')) {
      return 'hepatitis_b_1';
    }
    if (name.contains('hepatitis b (2)') || name.contains('гепатит b (2)')) {
      return 'hepatitis_b_2';
    }
    if (name.contains('dtp (1)') ||
        name.contains('акдс (1)') ||
        name.contains('akds (1)')) {
      return 'akds_1';
    }
    if (name.contains('dtp (2)') ||
        name.contains('акдс (2)') ||
        name.contains('akds (2)')) {
      return 'akds_2';
    }
    if (name.contains('dtp (3)') ||
        name.contains('акдс (3)') ||
        name.contains('akds (3)')) {
      return 'akds_3';
    }
    return name.replaceAll(' ', '_').replaceAll(RegExp(r'[^a-z0-9_]+'), '');
  }
}
