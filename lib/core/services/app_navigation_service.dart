import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movixapp/core/routes/nav_key.dart';
import 'package:movixapp/features/auth/views/reset_password_view.dart';

class AppNavigationService {
  AppNavigationService._();

  static final AppNavigationService instance = AppNavigationService._();

  GlobalKey<NavigatorState> get navigatorKey => NavKey.navigatorKey;

  String? _pendingOobCode;
  String? _lastHandledOobCode;

  Future<void> handlePasswordResetLink(String oobCode) async {
    // Avoid navigating twice for the same reset link.
    if (oobCode == _lastHandledOobCode) return;

    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      _pendingOobCode = oobCode;
      return;
    }

    try {
      final email = await FirebaseAuth.instance.verifyPasswordResetCode(
        oobCode,
      );
      debugPrint('Password reset code is valid for email: $email');
    } on FirebaseAuthException catch (e) {
      _lastHandledOobCode = oobCode;
      _pendingOobCode = null;
      navigator.pushNamedAndRemoveUntil('/login', (route) => false);
      debugPrint('Error verifying password reset code: ${e.message}');
      return;
    }

    _lastHandledOobCode = oobCode;
    _pendingOobCode = null;

    navigator.push(
      MaterialPageRoute<void>(builder: (_) => ResetPassword(oobCode: oobCode)),
    );
  }

  Future<void> handlePendingPasswordResetLink() async {
    final oobCode = _pendingOobCode;
    _pendingOobCode = null;
    if (oobCode == null) return;
    await handlePasswordResetLink(oobCode);
  }

  Future<void> clearPasswordResetLink() async {
    _pendingOobCode = null;
  }
}
