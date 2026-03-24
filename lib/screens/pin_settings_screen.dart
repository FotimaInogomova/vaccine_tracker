import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';

class PinSettingsScreen extends StatefulWidget {
  const PinSettingsScreen({super.key});

  @override
  State<PinSettingsScreen> createState() => _PinSettingsScreenState();
}

class _PinSettingsScreenState extends State<PinSettingsScreen> {
  bool _pinEnabled = false;
  bool _biometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final pin = await AuthService.instance.isPinEnabled();
    final bio = await AuthService.instance.isBiometricEnabled();

    if (!mounted) return;
    setState(() {
      _pinEnabled = pin;
      _biometricsEnabled = bio;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.security),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(loc.enablePin),
            value: _pinEnabled,
            onChanged: (value) async {
              if (value) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PinSetupScreen(),
                  ),
                );
              } else {
                await AuthService.instance.disablePin();
                await AuthService.instance.setBiometricEnabled(false);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(loc.pinDisabled)),
                );
              }
              await _loadSettings();
            },
          ),
          if (_pinEnabled)
            SwitchListTile(
              title: Text(loc.useBiometrics),
              value: _biometricsEnabled,
              onChanged: (value) async {
                await AuthService.instance.setBiometricEnabled(value);
                await _loadSettings();
              },
            ),
        ],
      ),
    );
  }
}

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _pinController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _savePin() async {
    final loc = AppLocalizations.of(context)!;
    final pin = _pinController.text.trim();
    final confirm = _confirmController.text.trim();

    if (pin.length != 4 || confirm.length != 4 || pin != confirm) {
      setState(() => _error = loc.wrongPin);
      return;
    }

    setState(() {
      _error = null;
      _saving = true;
    });

    await AuthService.instance.setPin(pin);

    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.pinSaved)),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.changePin),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _pinController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: InputDecoration(
                labelText: loc.enterPin,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              obscureText: true,
              decoration: InputDecoration(
                labelText: loc.confirmPin,
                border: const OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _savePin,
                child: _saving
                    ? const CircularProgressIndicator()
                    : Text(loc.save),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
