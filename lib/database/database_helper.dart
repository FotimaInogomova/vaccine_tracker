import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../core/app_exception.dart';
import '../models/child.dart';
import '../models/vaccination_record.dart';
import '../models/vaccine.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  static const _dbName = 'vaccine_tracker.db';
  static const _dbVersion = 16;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onDowngrade: onDatabaseDowngradeDelete,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE parent(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE children (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        birthDate TEXT NOT NULL,
        parentId INTEGER,
        medicalExemptionUntil TEXT,
        allergies TEXT,
        chronicDiseases TEXT,
        notes TEXT,
        showRecommended INTEGER NOT NULL DEFAULT 0,
        showOptional INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(parentId) REFERENCES parent(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE vaccines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        vaccineKey TEXT NOT NULL DEFAULT '',
        ageInMonths INTEGER NOT NULL,
        type TEXT NOT NULL DEFAULT 'national',
        minIntervalMonths INTEGER NOT NULL DEFAULT 0,
        contraindications TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE child_vaccinations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        child_id INTEGER NOT NULL,
        vaccine_id INTEGER NOT NULL,
        doneAt TEXT,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL,
        UNIQUE(child_id, vaccine_id),
        FOREIGN KEY(child_id) REFERENCES children(id) ON DELETE CASCADE,
        FOREIGN KEY(vaccine_id) REFERENCES vaccines(id)
      )
    ''');

    await db.execute('CREATE INDEX idx_children_parent ON children(parentId)');
    await db.execute(
      'CREATE INDEX idx_vaccinations_child ON child_vaccinations(child_id)',
    );

    await _seedVaccines(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 5) {
      await _migrateToV5(db);
    }
    if (oldVersion < 6) {
      await _migrateToV6(db);
    }
    if (oldVersion < 7) {
      await _migrateToV7(db);
    }
    if (oldVersion < 8) {
      await _migrateToV8(db);
    }
    if (oldVersion < 9) {
      await _migrateToV9(db);
    }
    if (oldVersion < 10) {
      await _migrateToV10(db);
    }
    if (oldVersion < 11) {
      await _migrateToV11(db);
    }
    if (oldVersion < 12) {
      await _migrateToV12(db);
    }
    if (oldVersion < 13) {
      await _migrateToV13(db);
    }
    if (oldVersion < 14) {
      await _migrateToV14(db);
    }
    if (oldVersion < 15) {
      await _migrateToV15(db);
    }
    if (oldVersion < 16) {
      await _migrateToV16(db);
    }
  }

  Future<void> _migrateToV5(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE child_vaccinations_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          child_id INTEGER NOT NULL,
          vaccine_id INTEGER NOT NULL,
          doneAt TEXT,
          createdAt TEXT NOT NULL DEFAULT '',
          updatedAt TEXT NOT NULL DEFAULT '',
          UNIQUE(child_id, vaccine_id),
          FOREIGN KEY(child_id) REFERENCES children(id) ON DELETE CASCADE,
          FOREIGN KEY(vaccine_id) REFERENCES vaccines(id)
        )
      ''');

      await txn.execute('''
        INSERT INTO child_vaccinations_new (id, child_id, vaccine_id, doneAt, createdAt, updatedAt)
        SELECT id, child_id, vaccine_id, doneAt,
               COALESCE(doneAt, ''),
               COALESCE(doneAt, '')
        FROM child_vaccinations
      ''');

      await txn.execute('DROP TABLE child_vaccinations');
      await txn.execute(
        'ALTER TABLE child_vaccinations_new RENAME TO child_vaccinations',
      );

      await txn.execute(
        'CREATE INDEX idx_vaccinations_child ON child_vaccinations(child_id)',
      );
    });
  }

  Future<void> _migrateToV6(Database db) async {
    await db.transaction((txn) async {
      await txn.execute(
        'ALTER TABLE vaccines ADD COLUMN minIntervalMonths INTEGER NOT NULL DEFAULT 0',
      );
      await txn.rawUpdate(
        'UPDATE vaccines SET minIntervalMonths = 2 WHERE ageInMonths IN (4, 6)',
      );
    });
  }

  Future<void> _migrateToV7(Database db) async {
    await db.transaction((txn) async {
      await txn.execute(
        'ALTER TABLE children ADD COLUMN medicalExemptionUntil TEXT',
      );
    });
  }

  Future<void> _migrateToV8(Database db) async {
    await db.transaction((txn) async {
      await txn.execute(
        "ALTER TABLE vaccines ADD COLUMN type TEXT NOT NULL DEFAULT 'national'",
      );
      await txn.rawInsert('''
        INSERT INTO vaccines(name, ageInMonths, type, minIntervalMonths)
        SELECT 'Influenza', 6, 'recommended', 0
        WHERE NOT EXISTS(SELECT 1 FROM vaccines WHERE name = 'Influenza')
        ''');
      await txn.rawInsert('''
        INSERT INTO vaccines(name, ageInMonths, type, minIntervalMonths)
        SELECT 'Varicella', 12, 'recommended', 0
        WHERE NOT EXISTS(SELECT 1 FROM vaccines WHERE name = 'Varicella')
        ''');
    });
  }

  Future<void> _migrateToV9(Database db) async {
    await db.transaction((txn) async {
      await txn.execute(
        "ALTER TABLE vaccines ADD COLUMN vaccineKey TEXT NOT NULL DEFAULT ''",
      );
      await txn.rawUpdate('''
        UPDATE vaccines
        SET vaccineKey = CASE
          WHEN LOWER(name) IN ('bcg', 'бцж') THEN 'bcg'
          WHEN LOWER(name) IN ('hepatitis b (1)', 'гепатит b (1)') THEN 'hepatitis_b_1'
          WHEN LOWER(name) IN ('hepatitis b (2)', 'гепатит b (2)') THEN 'hepatitis_b_2'
          WHEN LOWER(name) IN ('dtp (1)', 'акдс (1)', 'akds (1)') THEN 'akds_1'
          WHEN LOWER(name) IN ('dtp (2)', 'акдс (2)', 'akds (2)') THEN 'akds_2'
          WHEN LOWER(name) IN ('dtp (3)', 'акдс (3)', 'akds (3)') THEN 'akds_3'
          ELSE REPLACE(LOWER(name), ' ', '_')
        END
        WHERE vaccineKey = ''
        ''');
    });
  }

  Future<void> _migrateToV10(Database db) async {
    await db.transaction((txn) async {
      await txn.execute("ALTER TABLE vaccines ADD COLUMN disease TEXT");
      await txn.execute("ALTER TABLE vaccines ADD COLUMN description TEXT");
      await txn.execute("ALTER TABLE vaccines ADD COLUMN reactions TEXT");
    });
  }

  Future<void> _migrateToV11(Database db) async {
    await db.transaction((txn) async {
      await txn.rawUpdate(
        "UPDATE vaccines SET type = 'optional' WHERE type = 'custom'",
      );

      Future<void> insertIfMissing(Map<String, Object> row) async {
        await txn.rawInsert(
          '''
          INSERT INTO vaccines(name, vaccineKey, ageInMonths, type, disease, description, reactions, minIntervalMonths)
          SELECT ?, ?, ?, ?, '', '', '', ?
          WHERE NOT EXISTS(SELECT 1 FROM vaccines WHERE vaccineKey = ?)
          ''',
          [
            row['name'],
            row['vaccineKey'],
            row['ageInMonths'],
            row['type'],
            row['minIntervalMonths'],
            row['vaccineKey'],
          ],
        );
      }

      await insertIfMissing({
        'name': 'HPV',
        'vaccineKey': 'hpv',
        'ageInMonths': 108,
        'type': 'recommended',
        'minIntervalMonths': 0,
      });
      await insertIfMissing({
        'name': 'Pneumococcal',
        'vaccineKey': 'pneumococcal',
        'ageInMonths': 2,
        'type': 'recommended',
        'minIntervalMonths': 0,
      });
      await insertIfMissing({
        'name': 'Meningococcal',
        'vaccineKey': 'meningococcal',
        'ageInMonths': 9,
        'type': 'recommended',
        'minIntervalMonths': 0,
      });
      await insertIfMissing({
        'name': 'Rotavirus',
        'vaccineKey': 'rotavirus',
        'ageInMonths': 2,
        'type': 'optional',
        'minIntervalMonths': 0,
      });
      await insertIfMissing({
        'name': 'Hib',
        'vaccineKey': 'hib',
        'ageInMonths': 2,
        'type': 'optional',
        'minIntervalMonths': 0,
      });
    });
  }

  Future<void> _migrateToV12(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('''
        CREATE TABLE vaccines_new (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          vaccineKey TEXT NOT NULL,
          ageInMonths INTEGER NOT NULL,
          type TEXT NOT NULL,
          minIntervalMonths INTEGER NOT NULL DEFAULT 0
        )
      ''');

      await txn.execute('''
        INSERT INTO vaccines_new (id, name, vaccineKey, ageInMonths, type, minIntervalMonths)
        SELECT id, name, vaccineKey, ageInMonths, type, minIntervalMonths
        FROM vaccines
      ''');

      await txn.execute('DROP TABLE vaccines');
      await txn.execute('ALTER TABLE vaccines_new RENAME TO vaccines');
    });
  }

  Future<void> _migrateToV13(Database db) async {
    await db.transaction((txn) async {
      await txn.execute(
        'ALTER TABLE children ADD COLUMN showRecommended INTEGER NOT NULL DEFAULT 0',
      );
      await txn.execute(
        'ALTER TABLE children ADD COLUMN showOptional INTEGER NOT NULL DEFAULT 0',
      );
    });
  }

  Future<void> _migrateToV14(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('ALTER TABLE children ADD COLUMN notes TEXT');
    });
  }

  Future<void> _migrateToV15(Database db) async {
    await db.transaction((txn) async {
      await txn.execute(
        'ALTER TABLE vaccines ADD COLUMN contraindications TEXT',
      );
    });
  }

  Future<void> _migrateToV16(Database db) async {
    await db.transaction((txn) async {
      await txn.execute('ALTER TABLE children ADD COLUMN allergies TEXT');
      await txn.execute('ALTER TABLE children ADD COLUMN chronicDiseases TEXT');
    });
  }

  Future<void> _seedVaccines(Database db) async {
    final existing = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM vaccines'),
    );

    if (existing != null && existing > 0) return;

    final vaccines = [
      {
        'name': 'BCG',
        'vaccineKey': 'bcg',
        'ageInMonths': 0,
        'type': 'national',
        'minIntervalMonths': 0,
      },
      {
        'name': 'Hepatitis B (1)',
        'vaccineKey': 'hepatitis_b_1',
        'ageInMonths': 0,
        'type': 'national',
        'minIntervalMonths': 0,
      },
      {
        'name': 'Hepatitis B (2)',
        'vaccineKey': 'hepatitis_b_2',
        'ageInMonths': 1,
        'type': 'national',
        'minIntervalMonths': 0,
      },
      {
        'name': 'DTP (1)',
        'vaccineKey': 'akds_1',
        'ageInMonths': 2,
        'type': 'national',
        'minIntervalMonths': 0,
      },
      {
        'name': 'DTP (2)',
        'vaccineKey': 'akds_2',
        'ageInMonths': 4,
        'type': 'national',
        'minIntervalMonths': 2,
      },
      {
        'name': 'DTP (3)',
        'vaccineKey': 'akds_3',
        'ageInMonths': 6,
        'type': 'national',
        'minIntervalMonths': 2,
      },
      {
        'name': 'MMR',
        'vaccineKey': 'kpk',
        'ageInMonths': 12,
        'type': 'national',
        'minIntervalMonths': 0,
      },
      {
        'name': 'Influenza',
        'vaccineKey': 'influenza',
        'ageInMonths': 6,
        'type': 'recommended',
        'minIntervalMonths': 0,
      },
      {
        'name': 'Varicella',
        'vaccineKey': 'varicella',
        'ageInMonths': 12,
        'type': 'recommended',
        'minIntervalMonths': 0,
      },
      {
        'name': 'HPV',
        'vaccineKey': 'hpv',
        'ageInMonths': 108,
        'type': 'recommended',
        'minIntervalMonths': 0,
      },
      {
        'name': 'Pneumococcal',
        'vaccineKey': 'pneumococcal',
        'ageInMonths': 2,
        'type': 'recommended',
        'minIntervalMonths': 0,
      },
      {
        'name': 'Meningococcal',
        'vaccineKey': 'meningococcal',
        'ageInMonths': 9,
        'type': 'recommended',
        'minIntervalMonths': 0,
      },
      {
        'name': 'Rotavirus',
        'vaccineKey': 'rotavirus',
        'ageInMonths': 2,
        'type': 'optional',
        'minIntervalMonths': 0,
      },
      {
        'name': 'Hib',
        'vaccineKey': 'hib',
        'ageInMonths': 2,
        'type': 'optional',
        'minIntervalMonths': 0,
      },
    ];

    for (final v in vaccines) {
      await db.insert('vaccines', v);
    }
  }

  Future<int> insertChild(Child child, int parentId) async {
    final db = await database;

    final map = child.toMap();
    map['parentId'] = parentId;

    return db.insert('children', map);
  }

  Future<List<Child>> getChildrenByParent(int parentId) async {
    final db = await database;
    final result = await db.query(
      'children',
      where: 'parentId = ?',
      whereArgs: [parentId],
    );
    return result.map((e) => Child.fromMap(e)).toList();
  }

  Future<Child?> getChildById(int childId) async {
    final db = await database;
    final result = await db.query(
      'children',
      where: 'id = ?',
      whereArgs: [childId],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return Child.fromMap(result.first);
  }

  Future<List<Vaccine>> getVaccines() async {
    final db = await database;
    final result = await db.query('vaccines');
    return result.map((e) => Vaccine.fromMap(e)).toList();
  }

  Future<int> deleteChild(int id) async {
    final db = await database;
    return db.delete('children', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> markVaccineDone({
    required int childId,
    required int vaccineId,
    required DateTime doneDate,
  }) async {
    final db = await database;
    await _validateVaccinationDate(
      db: db,
      childId: childId,
      vaccineId: vaccineId,
      doneDate: doneDate,
    );

    final now = DateTime.now().toIso8601String();
    await db.insert('child_vaccinations', {
      'child_id': childId,
      'vaccine_id': vaccineId,
      'doneAt': doneDate.toIso8601String(),
      'createdAt': now,
      'updatedAt': now,
    });
  }

  String _vaccineSeriesKey(String vaccineName) {
    final idx = vaccineName.indexOf('(');
    final base = idx == -1 ? vaccineName : vaccineName.substring(0, idx);
    return base.trim().toLowerCase();
  }

  Future<void> unmarkVaccine({
    required int childId,
    required int vaccineId,
  }) async {
    final db = await database;

    await db.delete(
      'child_vaccinations',
      where: 'child_id = ? AND vaccine_id = ?',
      whereArgs: [childId, vaccineId],
    );
  }

  Future<void> updateMedicalExemption(int childId, DateTime until) async {
    final db = await database;
    await db.update(
      'children',
      {'medicalExemptionUntil': until.toIso8601String()},
      where: 'id = ?',
      whereArgs: [childId],
    );
  }

  Future<void> updateVaccinePreferences(
    int childId,
    bool showRecommended,
    bool showOptional,
  ) async {
    final db = await database;
    await db.update(
      'children',
      {
        'showRecommended': showRecommended ? 1 : 0,
        'showOptional': showOptional ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [childId],
    );
  }

  Future<void> updateChildNotes(int childId, String notes) async {
    final db = await database;
    await db.update(
      'children',
      {'notes': notes.trim().isEmpty ? null : notes.trim()},
      where: 'id = ?',
      whereArgs: [childId],
    );
  }

  Future<void> updateChildHealthProfile({
    required int childId,
    String? allergies,
    String? chronicDiseases,
    String? notes,
  }) async {
    final db = await database;
    await db.update(
      'children',
      {
        'allergies': _nullableText(allergies),
        'chronicDiseases': _nullableText(chronicDiseases),
        'notes': _nullableText(notes),
      },
      where: 'id = ?',
      whereArgs: [childId],
    );
  }

  String? _nullableText(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
  }

  Future<void> updateVaccinationDate(
    int id,
    DateTime newDate, {
    int? childId,
  }) async {
    final db = await database;

    late final int resolvedChildId;
    late final int resolvedVaccineId;

    if (childId != null) {
      resolvedChildId = childId;
      resolvedVaccineId = id;
    } else {
      final existing = await db.query(
        'child_vaccinations',
        columns: ['child_id', 'vaccine_id'],
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (existing.isEmpty) {
        throw const AppValidationException(ValidationErrorCode.invalidData);
      }

      resolvedChildId = existing.first['child_id'] as int;
      resolvedVaccineId = existing.first['vaccine_id'] as int;
    }

    await _validateVaccinationDate(
      db: db,
      childId: resolvedChildId,
      vaccineId: resolvedVaccineId,
      doneDate: newDate,
    );

    final payload = {
      'doneAt': newDate.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };

    if (childId != null) {
      await db.update(
        'child_vaccinations',
        payload,
        where: 'child_id = ? AND vaccine_id = ?',
        whereArgs: [childId, id],
      );
      return;
    }

    await db.update(
      'child_vaccinations',
      payload,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<VaccinationRecord>> getVaccinationHistory(int childId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT
        cv.id,
        cv.vaccine_id,
        cv.doneAt AS date,
        v.vaccineKey AS vaccineKey
      FROM child_vaccinations cv
      INNER JOIN vaccines v ON v.id = cv.vaccine_id
      WHERE cv.child_id = ?
      ORDER BY cv.doneAt DESC
      ''',
      [childId],
    );

    return result.map((e) => VaccinationRecord.fromMap(e)).toList();
  }

  Future<List<int>> getDoneVaccineIds(int childId) async {
    final db = await database;
    final rows = await db.query(
      'child_vaccinations',
      columns: ['vaccine_id'],
      where: 'child_id = ?',
      whereArgs: [childId],
    );
    return rows.map((r) => r['vaccine_id'] as int).toList();
  }

  Future<void> _validateVaccinationDate({
    required Database db,
    required int childId,
    required int vaccineId,
    required DateTime doneDate,
  }) async {
    final child = await db.query(
      'children',
      where: 'id = ?',
      whereArgs: [childId],
      limit: 1,
    );
    final vaccine = await db.query(
      'vaccines',
      where: 'id = ?',
      whereArgs: [vaccineId],
      limit: 1,
    );

    if (child.isEmpty || vaccine.isEmpty) {
      throw const AppValidationException(ValidationErrorCode.invalidData);
    }

    if (doneDate.isAfter(DateTime.now())) {
      throw const AppValidationException(
        ValidationErrorCode.dateCannotBeInFuture,
      );
    }

    final birthDate = DateTime.parse(child.first['birthDate'] as String);
    final requiredAge = vaccine.first['ageInMonths'] as int;
    final minDate = birthDate.add(Duration(days: requiredAge * 30));
    if (doneDate.isBefore(minDate)) {
      throw const AppValidationException(
        ValidationErrorCode.vaccinationDateTooEarly,
      );
    }

    final exemption = child.first['medicalExemptionUntil'] as String?;
    if (exemption != null && exemption.isNotEmpty) {
      final until = DateTime.parse(exemption);
      if (doneDate.isBefore(until)) {
        throw const AppValidationException(
          ValidationErrorCode.medicalExemptionActive,
        );
      }
    }

    final minIntervalMonths = (vaccine.first['minIntervalMonths'] as int?) ?? 0;
    if (minIntervalMonths <= 0) {
      return;
    }

    final currentSeries = _vaccineSeriesKey(vaccine.first['name'] as String);
    final previousVaccines = await db.rawQuery(
      '''
      SELECT cv.doneAt, v.name
      FROM child_vaccinations cv
      INNER JOIN vaccines v ON v.id = cv.vaccine_id
      WHERE cv.child_id = ? AND cv.vaccine_id != ?
      ORDER BY cv.doneAt DESC
      ''',
      [childId, vaccineId],
    );

    for (final previous in previousVaccines) {
      final prevName = previous['name'] as String?;
      final prevDoneAt = previous['doneAt'] as String?;
      if (prevName == null || prevDoneAt == null || prevDoneAt.isEmpty) {
        continue;
      }
      if (_vaccineSeriesKey(prevName) != currentSeries) {
        continue;
      }

      final lastDate = DateTime.parse(prevDoneAt);
      final diffMonths = doneDate.difference(lastDate).inDays / 30;
      if (diffMonths < minIntervalMonths) {
        throw const AppValidationException(
          ValidationErrorCode.minimumIntervalNotMet,
        );
      }
      break;
    }
  }
}
