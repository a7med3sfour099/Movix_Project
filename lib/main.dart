import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movixapp/core/services/app_link_service.dart';
import 'package:movixapp/features/auth/views/login_view.dart';
import 'package:movixapp/features/auth/views/reset_password_view.dart';
import 'package:movixapp/firebase_options.dart';
import 'package:movixapp/features/auth/views/signup_view.dart';
import 'package:movixapp/features/auth/views/change_password_view.dart';
import 'package:movixapp/features/settings/views/settings_view.dart';
import 'package:movixapp/features/auth/views/forget_password.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final AppLinkService appLinkService = AppLinkService();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

String? _pendingOobCode;
String? _lastHandledOobCode;

void _openResetPassword(String oobCode) {
  // Prevent opening the same reset link twice.
  if (_lastHandledOobCode == oobCode) return;

  final navigator = navigatorKey.currentState;

  if (navigator == null) {
    _pendingOobCode = oobCode;
    return;
  }

  _lastHandledOobCode = oobCode;
  _pendingOobCode = null;

  navigator.push(
    MaterialPageRoute(builder: (_) => ResetPassword(oobCode: oobCode)),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await appLinkService.init(onPasswordResetLink: _openResetPassword);
  runApp(const MyApp());

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final code = _pendingOobCode;
    if (code != null) {
      _openResetPassword(code);
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          // home: SignupView(),
          home: LoginView(),
          // home: changePassword(),
          // home: ForgetPassword(),
          // home: SettingsView(),
        );
      },
    );
  }
}
