import 'package:flutter/material.dart';
import 'package:movixapp/core/routes/nav_key.dart';
import 'package:movixapp/features/auth/views/reset_password_view.dart';

class AppNavigationService {
  AppNavigationService._();

  static final AppNavigationService instance = AppNavigationService._();

  GlobalKey<NavigatorState> get navigatorKey => NavKey.navigatorKey;

  String? _pendingOobCode;

  Future<void> handlePasswordResetLink(String oobCode) async {
    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      _pendingOobCode = oobCode;
      return;
    }

    _pendingOobCode = null;

    navigator.push(
      MaterialPageRoute<void>(
        builder: (_) => ResetPassword(oobCode: oobCode),
      ),
    );
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
