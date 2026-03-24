import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';

class BackupService {
  static Future<void> exportDatabase() async {
    final dbPath = await getDatabasesPath();
    final dbFile = File('$dbPath/vaccine_tracker.db');

    if (!await dbFile.exists()) {
      throw Exception('Database file not found');
    }

    final directory = await getTemporaryDirectory();
    final backupPath = '${directory.path}/vaccine_backup.db';

    final backupFile = await dbFile.copy(backupPath);
    await Share.shareXFiles([XFile(backupFile.path)]);
  }
}
