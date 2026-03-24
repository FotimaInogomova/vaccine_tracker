import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  LocalAuthService._();
  static final instance = LocalAuthService._();

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate() async {
    try {
      final result = await _auth.authenticate(
        localizedReason: 'Подтвердите вход с помощью отпечатка пальца',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );

      debugPrint('BIOMETRIC RESULT = $result');
      return result;
    } catch (e) {
      debugPrint('BIOMETRIC ERROR: $e');
      return false;
    }
  }
}
