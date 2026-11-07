import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movixapp/core/routes/nav_key.dart';

class AppNavigationService {
  AppNavigationService._();

  static final AppNavigationService instance = AppNavigationService._();

  GlobalKey<NavigatorState> get navigatorKey => NavKey.navigatorKey;

  String? _pendingOobCode;
  String? _lastHandledOobCode;
  bool _isVerifying = false;

  Future<void> handlePasswordResetLink(String oobCode) async {
    final navigator = navigatorKey.currentState;

    if (_isVerifying || oobCode == _lastHandledOobCode) return;

    if (navigator == null) {
      _pendingOobCode = oobCode;
      return;
    }

    _isVerifying = true;
    _lastHandledOobCode = oobCode;

    /// Verify the password reset code with Firebase Authentication
    /// To ensure that the code is valid and corresponds to a user account.(Emulator)
    try {
      final email = await FirebaseAuth.instance.verifyPasswordResetCode(
        oobCode,
      );
      debugPrint('Password reset code is valid for email: $email');
      _lastHandledOobCode = oobCode;
    } on FirebaseAuthException catch (e) {
      // _lastHandledOobCode = oobCode;
      _pendingOobCode = null;
      _isVerifying = false;
      navigator.pushNamedAndRemoveUntil('/login', (route) => false);
      debugPrint('Error verifying password reset code: ${e.message}');
      return;
    } catch (e) {
      _pendingOobCode = null;
      _isVerifying = false;
      debugPrint('Error verifying password reset code: $e');
      return;
    }

    _pendingOobCode = null;
    _isVerifying = false;

    navigator.pushNamed('/reset-password', arguments: oobCode);
  }

  Future<void> handlePendingPasswordResetLink() async {
    final oobCode = _pendingOobCode;
    if (oobCode == null) return;

    if (navigatorKey.currentState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        handlePendingPasswordResetLink();
      });
      return;
    }

    _pendingOobCode = null;
    await handlePasswordResetLink(oobCode);
  }

  Future<void> clearPasswordResetLink() async {
    _pendingOobCode = null;
  }
}
