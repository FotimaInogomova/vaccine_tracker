import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  Locale _locale = const Locale('ru');
  static const _localeKey = 'app_locale';

  Locale get locale => _locale;

  /// Загрузка языка при старте приложения
  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_localeKey);

    if (savedCode != null) {
      _locale = Locale(savedCode);
      notifyListeners();
    }
  }

  void changeLanguage(String code) {
    _locale = Locale(code);
    notifyListeners();
    _saveLocale(code);
  }

  Future<void> _saveLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, code);
  }
}
