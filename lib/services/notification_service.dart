import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../l10n/app_localizations.dart';
import '../utils/vaccine_localizer.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();

  NotificationService._internal();

  static const _localeKey = 'app_locale';
  static const _enabledKey = 'notifications_enabled';
  static const _daysBeforeKey = 'notify_days_before';
  static const _overdueEnabledKey = 'notify_overdue';

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _notifications.initialize(initSettings);

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();

    final loc = await _currentLoc();

    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        'vaccines_today',
        loc.reminderChannelName,
        description: loc.reminderChannelDescription,
        importance: Importance.high,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        'vaccines_smart',
        loc.reminderChannelName,
        description: loc.reminderChannelDescription,
        importance: Importance.high,
      ),
    );

    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        'vaccine_channel',
        loc.reminderChannelName,
        description: loc.reminderChannelDescription,
        importance: Importance.high,
      ),
    );
  }

  Future<void> scheduleUpcomingReminder({
    required int id,
    required String childName,
    required String vaccineKey,
    required int daysBefore,
    required DateTime date,
  }) async {
    final loc = await _currentLoc();
    final vaccineName = VaccineLocalizer.translate(loc, vaccineKey);

    await scheduleVaccineReminder(
      id: id,
      title: loc.smartReminderSoonTitle,
      body: loc.smartReminderSoonBody(childName, vaccineName, daysBefore),
      date: date,
    );
  }

  Future<void> scheduleDueReminder({
    required int id,
    required String childName,
    required String vaccineKey,
    required DateTime date,
  }) async {
    final loc = await _currentLoc();
    final vaccineName = VaccineLocalizer.translate(loc, vaccineKey);

    await scheduleVaccineReminder(
      id: id,
      title: loc.smartReminderDueTitle,
      body: loc.smartReminderDueBody(childName, vaccineName),
      date: date,
    );
  }

  Future<void> scheduleVaccineReminder({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    if (!await isEnabled()) return;
    if (date.isBefore(DateTime.now())) return;

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(date, tz.local),
      NotificationDetails(
        android: await _androidDetails('vaccine_channel'),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime date,
  }) async {
    await scheduleVaccineReminder(
      id: id,
      title: title,
      body: body,
      date: date,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> rescheduleAfterExemption({
    required int childId,
    required int vaccineId,
    required String childName,
    required String vaccineKey,
    required DateTime newDate,
  }) async {
    await cancelNotification(vaccineId * 100 + childId);
    await cancelNotification(vaccineId * 1000 + childId);

    final days = await daysBefore();

    await scheduleUpcomingReminder(
      id: vaccineId * 100 + childId,
      childName: childName,
      vaccineKey: vaccineKey,
      daysBefore: days,
      date: newDate.subtract(Duration(days: days)),
    );

    await scheduleDueReminder(
      id: vaccineId * 1000 + childId,
      childName: childName,
      vaccineKey: vaccineKey,
      date: newDate,
    );
  }

  Future<void> scheduleOverdueReminders({
    required int childId,
    required int vaccineId,
    required String childName,
    required String vaccineKey,
    required DateTime dueDate,
  }) async {
    if (!await isEnabled()) return;
    if (!await isOverdueEnabled()) return;

    final now = DateTime.now();
    if (now.isBefore(dueDate)) return;

    final daysOverdue = now.difference(dueDate).inDays;
    final nextStep = (daysOverdue ~/ 3 + 1) * 3;
    final nextReminderDate = dueDate.add(Duration(days: nextStep));

    if (nextReminderDate.isBefore(now)) return;

    final loc = await _currentLoc();
    final vaccineName = VaccineLocalizer.translate(loc, vaccineKey);

    await scheduleNotification(
      id: vaccineId * 10000 + childId,
      title: loc.smartReminderOverdueTitle,
      body: loc.smartReminderOverdueBody(childName, vaccineName, nextStep),
      date: nextReminderDate,
    );
  }

  Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? true;
  }

  Future<int> daysBefore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_daysBeforeKey) ?? 3;
  }

  Future<bool> isOverdueEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_overdueEnabledKey) ?? true;
  }

  Future<void> updateSettings({
    required bool enabled,
    required int daysBefore,
    required bool overdueEnabled,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
    await prefs.setInt(_daysBeforeKey, daysBefore);
    await prefs.setBool(_overdueEnabledKey, overdueEnabled);
  }

  Future<void> showTodaySummary(int count) async {
    if (count <= 0 || !await isEnabled()) return;

    final loc = await _currentLoc();

    await _notifications.show(
      0,
      loc.reminderTitle,
      loc.reminderBody(count),
      NotificationDetails(
        android: await _androidDetails('vaccines_today'),
      ),
    );
  }

  Future<void> maybeShowSmartReminder({
    required int childId,
    required String childName,
    required int vaccineId,
    required String vaccineKey,
    required int daysUntilDue,
  }) async {
    if (!await isEnabled()) return;

    final rule = _smartRule(daysUntilDue);
    if (rule == null) return;

    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString(_localeKey) ?? 'ru';
    final loc = _locForCode(localeCode);
    final vaccineName = VaccineLocalizer.translate(loc, vaccineKey);

    final marker = _smartMarker(rule, daysUntilDue);
    final reminderKey = 'smart_reminder_${childId}_${vaccineId}_$rule';
    if (prefs.getString(reminderKey) == marker) return;

    final id = (reminderKey + marker).hashCode & 0x7fffffff;

    await _notifications.show(
      id,
      _smartTitle(loc, rule),
      _smartBody(
        loc: loc,
        rule: rule,
        childName: childName,
        vaccineName: vaccineName,
        daysUntilDue: daysUntilDue,
      ),
      NotificationDetails(
        android: await _androidDetails('vaccines_smart', localeCode: localeCode),
      ),
    );

    await prefs.setString(reminderKey, marker);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  String? _smartRule(int daysUntilDue) {
    if (daysUntilDue == 3) return 'pre3';
    if (daysUntilDue == 0) return 'due';
    if (daysUntilDue < 0 && daysUntilDue.abs() % 3 == 0) return 'overdue';
    return null;
  }

  String _smartMarker(String rule, int daysUntilDue) {
    if (rule == 'overdue') {
      return 'step_${daysUntilDue.abs() ~/ 3}';
    }
    return rule;
  }

  String _smartTitle(AppLocalizations loc, String rule) {
    switch (rule) {
      case 'pre3':
        return loc.smartReminderSoonTitle;
      case 'due':
        return loc.smartReminderDueTitle;
      case 'overdue':
        return loc.smartReminderOverdueTitle;
      default:
        return loc.smartReminderDefaultTitle;
    }
  }

  String _smartBody({
    required AppLocalizations loc,
    required String rule,
    required String childName,
    required String vaccineName,
    required int daysUntilDue,
  }) {
    switch (rule) {
      case 'pre3':
        return loc.smartReminderSoonBody(
          childName,
          vaccineName,
          daysUntilDue,
        );
      case 'due':
        return loc.smartReminderDueBody(childName, vaccineName);
      case 'overdue':
        return loc.smartReminderOverdueBody(
          childName,
          vaccineName,
          daysUntilDue.abs(),
        );
      default:
        return loc.smartReminderDefaultBody(childName, vaccineName);
    }
  }

  Future<AppLocalizations> _currentLoc() async {
    final localeCode = await _getLocaleCode();
    return _locForCode(localeCode);
  }

  AppLocalizations _locForCode(String localeCode) {
    return lookupAppLocalizations(Locale(localeCode));
  }

  Future<String> _getLocaleCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_localeKey) ?? 'ru';
  }

  Future<AndroidNotificationDetails> _androidDetails(
    String channelId, {
    String? localeCode,
  }) async {
    final loc = localeCode == null
        ? await _currentLoc()
        : _locForCode(localeCode);

    return AndroidNotificationDetails(
      channelId,
      loc.reminderChannelName,
      channelDescription: loc.reminderChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
  }
}
