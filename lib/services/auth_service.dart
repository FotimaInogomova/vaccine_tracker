import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../database/database_helper.dart';

class AuthService {
  static final AuthService instance = AuthService._();
  AuthService._();

  final _storage = const FlutterSecureStorage();

  // ===== КЛЮЧИ =====
  static const _tokenKey = 'access_token';
  static const _pinKey = 'user_pin';
  static const _pinEnabledKey = 'pin_enabled';
  static const _biometricKey = 'biometric_enabled';

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  // ===== ЛОГИН =====
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: _tokenKey);
    return token != null;
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    email = email.trim().toLowerCase();

    final db = await DatabaseHelper.instance.database;
    final hash = _hashPassword(password);

    final result2 = await db.query(
      'parent',
      where: 'email = ? AND password_hash = ?',
      whereArgs: [email, hash],
      limit: 1,
    );

    if (result2.isEmpty) {
      return false;
    }

    await _storage.write(
      key: _tokenKey,
      value: 'token_$email',
    );
    return true;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    email = email.trim().toLowerCase();

    final db = await DatabaseHelper.instance.database;

    final existing = await db.query(
      'parent',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existing.isNotEmpty) {
      return false;
    }

    final hash = _hashPassword(password);

    await db.insert('parent', {
      'email': email,
      'password_hash': hash,
      'name': name,
    });

    await login(email: email, password: password);

    return true;
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null || !token.startsWith('token_')) return false;

    final email = token.substring('token_'.length);
    if (email.isEmpty) return false;

    final db = await DatabaseHelper.instance.database;
    final result = await db.query(
      'parent',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isEmpty) return false;

    final storedHash = result.first['password_hash'] as String?;
    if (storedHash == null) return false;

    final oldHash = _hashPassword(oldPassword);
    if (storedHash != oldHash) return false;

    final newHash = _hashPassword(newPassword);
    await db.update(
      'parent',
      {'password_hash': newHash},
      where: 'email = ?',
      whereArgs: [email],
    );

    return true;
  }

  Future<void> logout() async {
    // ❗ очищаем ВСЁ (и токен, и PIN)
    await _storage.deleteAll();
  }
  Future<Map<String, dynamic>?> getCurrentParent() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null || !token.startsWith('token_')) return null;

    final email = token.substring('token_'.length);
    if (email.isEmpty) return null;

    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'parent',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return rows.first;
  }

  Future<bool> deleteCurrentParent() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null || !token.startsWith('token_')) return false;

    final email = token.substring('token_'.length);
    if (email.isEmpty) return false;

    final db = await DatabaseHelper.instance.database;
    final deleted = await db.delete(
      'parent',
      where: 'email = ?',
      whereArgs: [email],
    );

    await _storage.deleteAll();
    return deleted > 0;
  }

  Future<bool> deleteAccount() async {
    return deleteCurrentParent();
  }
  // ===== PIN =====
  Future<void> setPin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
    await _storage.write(key: _pinEnabledKey, value: 'true');
  }
Future<void> setBiometricEnabled(bool enabled) async {
  await _storage.write(
    key: _biometricKey,
    value: enabled.toString(),
  );
}
  Future<String?> getPin() async {
    return await _storage.read(key: _pinKey);
  }

  Future<bool> isPinEnabled() async {
    return await _storage.read(key: _pinEnabledKey) == 'true';
  }
Future<bool> isBiometricEnabled() async {
  final value = await _storage.read(key: _biometricKey);
  return value == 'true';
}

  Future<void> disablePin() async {
    await _storage.delete(key: _pinKey);
    await _storage.delete(key: _pinEnabledKey);
  }
}
