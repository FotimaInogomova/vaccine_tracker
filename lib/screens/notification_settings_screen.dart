import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _loading = true;
  bool _enabled = true;
  bool _overdueEnabled = true;
  int _daysBefore = 3;

  static const _dayOptions = [1, 2, 3, 5, 7];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await NotificationService.instance.isEnabled();
    final daysBefore = await NotificationService.instance.daysBefore();
    final overdueEnabled = await NotificationService.instance.isOverdueEnabled();

    if (!mounted) return;
    setState(() {
      _enabled = enabled;
      _daysBefore = _dayOptions.contains(daysBefore) ? daysBefore : 3;
      _overdueEnabled = overdueEnabled;
      _loading = false;
    });
  }

  Future<void> _save() async {
    await NotificationService.instance.updateSettings(
      enabled: _enabled,
      daysBefore: _daysBefore,
      overdueEnabled: _overdueEnabled,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.notificationSettings),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Card(
                  child: SwitchListTile(
                    title: Text(loc.enableNotifications),
                    value: _enabled,
                    onChanged: (value) async {
                      setState(() => _enabled = value);
                      await _save();
                    },
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    title: Text(loc.remindBefore),
                    trailing: DropdownButton<int>(
                      value: _daysBefore,
                      items: _dayOptions
                          .map(
                            (d) => DropdownMenuItem<int>(
                              value: d,
                              child: Text(loc.daysCount(d)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) async {
                        if (value == null) return;
                        setState(() => _daysBefore = value);
                        await _save();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: SwitchListTile(
                    title: Text(loc.enableOverdueReminders),
                    value: _overdueEnabled,
                    onChanged: (value) async {
                      setState(() => _overdueEnabled = value);
                      await _save();
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  loc.settingsAppliedImmediately,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
    );
  }
}

