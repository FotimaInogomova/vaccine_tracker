import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../l10n/app_localizations.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../services/theme_service.dart';
import '../utils/slide_route.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';
import 'notification_settings_screen.dart';
import 'pin_settings_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).padding.bottom + 80;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(24, 24, 24, bottomInset),
        children: [
          _buildHeader(context),
          const SizedBox(height: 32),
          _buildSectionTitle(context, loc.account),
          const SizedBox(height: 16),
          _settingsTile(
            context,
            icon: Icons.person_outline,
            title: loc.profile,
            onTap: () {
              Navigator.push(
                context,
                slideRoute(const ProfileScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _settingsTile(
            context,
            icon: Icons.security_outlined,
            title: loc.security,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PinSettingsScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          _settingsTile(
            context,
            icon: Icons.lock_outline,
            title: loc.changePassword,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChangePasswordScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Divider(color: theme.colorScheme.outlineVariant),
          const SizedBox(height: 24),
          _buildSectionTitle(context, loc.appearance),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      loc.darkMode,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Switch(
                    value: themeService.isDark,
                    onChanged: (_) => themeService.toggleTheme(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLanguageSelector(context),
          const SizedBox(height: 16),
          _settingsTile(
            context,
            icon: Icons.notifications_outlined,
            title: loc.notifications,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
          Divider(color: theme.colorScheme.outlineVariant),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () async {
              await AuthService.instance.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: Text(
              loc.logout,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          _buildAppVersion(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return FutureBuilder<Map<String, dynamic>?>(
      future: AuthService.instance.getCurrentParent(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final parent = snapshot.data!;
        final name = (parent['name'] as String?) ?? '';

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      ),
    );
  }

  Widget _settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final currentLang = Localizations.localeOf(context).languageCode;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.language_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  loc.language,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'ru', label: Text('RU')),
                ButtonSegment(value: 'uz', label: Text('UZ')),
                ButtonSegment(value: 'en', label: Text('EN')),
              ],
              selected: {currentLang},
              onSelectionChanged: (value) {
                VaccineTrackerApp.of(context).changeLanguage(value.first);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppVersion(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        }

        final info = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Text(
                info.appName,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                loc.appVersion(info.version),
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
