import 'package:flutter/material.dart';
import 'package:movixapp/core/routes/nav_key.dart';
import 'package:movixapp/features/auth/views/reset_password_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppNavigationService {
  AppNavigationService._();

  static final AppNavigationService instance = AppNavigationService._();

  GlobalKey<NavigatorState> get navigatorKey => NavKey.navigatorKey;

  String? _pendingOobCode;
  String? _lastHandledOobCode;

  static const String _completedKey = 'password_reset_completed';

  Future<void> handlePasswordResetLink(String oobCode) async {
    // Avoid navigating twice for the same reset link.
    if (oobCode == _lastHandledOobCode) return;

    final pref = await SharedPreferences.getInstance();
    if (pref.getBool(_completedKey) == true) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/login',
        (route) => false,
      );
      return;
    }

    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      _pendingOobCode = oobCode;
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
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_completedKey, true);
  }
}
