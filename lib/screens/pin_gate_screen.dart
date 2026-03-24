import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/local_auth_service.dart';

class PinGateScreen extends StatefulWidget {
  final Widget? child;

  const PinGateScreen({super.key, this.child});

  @override
  State<PinGateScreen> createState() => _PinGateScreenState();
}

class _PinGateScreenState extends State<PinGateScreen> {
  final TextEditingController _pinController = TextEditingController();
  String? _error;
  bool _checkingBio = false;
  double _opacity = 0.0;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _opacity = 1.0);
    });
  }

  Future<void> _useBiometric() async {
    setState(() => _checkingBio = true);

    final enabled = await AuthService.instance.isBiometricEnabled();
    if (!enabled) {
      setState(() => _checkingBio = false);
      return;
    }

    final available = await LocalAuthService.instance.isAvailable();
    if (!available) {
      setState(() => _checkingBio = false);
      return;
    }

    final success = await LocalAuthService.instance.authenticate();
    if (!mounted) return;

    setState(() => _checkingBio = false);

    if (success) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _checkPin() async {
    final savedPin = await AuthService.instance.getPin();

    if (_pinController.text == savedPin) {
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } else {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      setState(() {
        _error = loc.wrongPin;
        _pinController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SafeArea(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 400),
              opacity: _opacity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.lock_outline,
                            size: 40,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            loc.enterPin,
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            loc.confirmPin,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    _buildDots(),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FutureBuilder<bool>(
                      future: AuthService.instance.isBiometricEnabled(),
                      builder: (context, snap) {
                        if (snap.data != true) return const SizedBox.shrink();

                        return IconButton(
                          iconSize: 40,
                          onPressed: _checkingBio ? null : _useBiometric,
                          icon: _checkingBio
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(
                                  Icons.fingerprint,
                                  size: 32,
                                  color: theme.colorScheme.primary,
                                ),
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    _buildKeyboard(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    return Column(
      children: [
        for (var row in [
          ['1', '2', '3'],
          ['4', '5', '6'],
          ['7', '8', '9'],
          ['', '0', 'del'],
        ])
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: _buildKey(key),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildDots() {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final filled = index < _pinController.text.length;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: filled
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceVariant,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  Widget _buildKey(String value) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 72,
      height: 72,
      child: value.isEmpty
          ? const SizedBox.shrink()
          : Material(
              color: theme.colorScheme.primaryContainer,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  if (value == 'del') {
                    if (_pinController.text.isNotEmpty) {
                      setState(() {
                        _pinController.text = _pinController.text.substring(
                          0,
                          _pinController.text.length - 1,
                        );
                      });
                    }
                  } else {
                    if (_pinController.text.length < 4) {
                      setState(() {
                        _pinController.text += value;
                      });

                      if (_pinController.text.length == 4) {
                        _checkPin();
                      }
                    }
                  }
                },
                child: Center(
                  child: value == 'del'
                      ? Icon(
                          Icons.backspace_outlined,
                          size: 22,
                          color: theme.colorScheme.primary,
                        )
                      : Text(
                          value,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                ),
              ),
            ),
    );
  }
}
