import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../screens/change_password_screen.dart';
import '../screens/login_screen.dart';
import '../services/auth_service.dart';
import '../services/backup_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _parent;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadParent();
  }

  Future<void> _loadParent() async {
    final parent = await AuthService.instance.getCurrentParent();
    if (!mounted) return;

    setState(() {
      _parent = parent;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  Future<void> _confirmDelete() async {
    final loc = AppLocalizations.of(context)!;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(loc.deleteAccountTitle),
        content: Text(loc.deleteAccountMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await AuthService.instance.deleteAccount();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final name = _parent?['name'] ?? '';
    final email = _parent?['email'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.profile),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Column(
          children: [
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 52,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: TextStyle(
                  fontSize: 34,
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              email,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 40),

            Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: theme.colorScheme.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: const Icon(Icons.lock),
                title: Text(loc.changePassword),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChangePasswordScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: theme.colorScheme.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: const Icon(Icons.backup),
                title: Text(loc.backupData),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                onTap: () async {
                  try {
                    await BackupService.exportDatabase();
                  } catch (_) {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(loc.backupFailed)),
                    );
                  }
                },
              ),
            ),

            const SizedBox(height: 16),

            Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: theme.colorScheme.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                leading: const Icon(Icons.logout),
                title: Text(loc.logout),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                onTap: _logout,
              ),
            ),

            const SizedBox(height: 24),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                loc.deleteAccount,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: _confirmDelete,
            ),
          ],
        ),
      ),
    );
  }
}
