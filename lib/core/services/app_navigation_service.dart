import 'package:flutter/material.dart';
import 'package:movixapp/core/routes/nav_key.dart';
import 'package:movixapp/features/auth/views/reset_password_view.dart';

class AppNavigationService {
  AppNavigationService._();

  static final AppNavigationService instance = AppNavigationService._();

  GlobalKey<NavigatorState> get navigatorKey => NavKey.navigatorKey;

  String? _pendingOobCode;
  String? _lastHandledOobCode;

  void handlePasswordResetLink(String oobCode) {
    // Avoid navigating twice for the same reset link.
    if (oobCode == _lastHandledOobCode) return;

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

  void handlePendingPasswordResetLink() {
    final oobCode = _pendingOobCode;
    if (oobCode == null) return;

    handlePasswordResetLink(oobCode);
  }
}
