import 'package:flutter/material.dart';
import 'package:movixapp/features/auth/views/change_password_view.dart';
import 'package:movixapp/features/auth/views/forget_password.dart';
import 'package:movixapp/features/auth/views/login_view.dart';
import 'package:movixapp/features/auth/views/signup_view.dart';
import 'package:movixapp/features/home/views/home_screen.dart';
import 'package:movixapp/features/settings/views/settings_view.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/home': (context) => const HomeScreen(),
    '/login': (context) => const LoginView(),
    '/sign-up': (context) => const SignupView(),
    '/forget-password': (context) => const ForgetPassword(),
    '/change-password': (context) => ChangePassword(),
    '/setting': (context) => const SettingsView(),
  };
}
