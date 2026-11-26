import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/auth/cubit/change_password_cubit.dart';
import 'package:movixapp/features/auth/cubit/forget_password_cubit.dart';
import 'package:movixapp/features/auth/views/change_password_view.dart';
import 'package:movixapp/features/auth/views/forget_password_view.dart';
import 'package:movixapp/features/auth/views/login_view.dart';
import 'package:movixapp/features/auth/views/reset_password_view.dart';
import 'package:movixapp/features/auth/views/signup_view.dart';
import 'package:movixapp/features/home/screens/home_screen.dart';
import 'package:movixapp/features/profile/views/edit_profile_view.dart';
import 'package:movixapp/features/settings/views/about_us_view.dart';
import 'package:movixapp/features/settings/views/privacy_policy_view.dart';
import 'package:movixapp/features/settings/views/settings_view.dart';
import 'package:movixapp/features/settings/views/terms_and_conditions_view.dart';
import 'package:movixapp/features/onboarding/screens/onboarding_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes => {
    '/home': (context) => const HomeScreen(),
    '/login': (context) => const LoginView(),
    '/onboarding': (context) => const OnboardingScreen(),
    '/sign-up': (context) => const SignupView(),
    '/forget-password': (context) => BlocProvider(
      create: (_) => ForgetPasswordCubit(),
      child: const ForgetPassword(),
    ),
    '/reset-password': (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      final oobCode = args is String ? args : '';
      return ResetPassword(oobCode: oobCode);
    },
    '/change-password': (context) => BlocProvider(
      create: (_) => ChangePasswordCubit(),
      child: const ChangePassword(),
    ),
    '/edit-profile': (context) => const EditProfileView(),
    '/setting': (context) => const SettingsView(),
    '/about-us': (context) => const AboutUsView(),
    '/privacy-policy': (context) => const PrivacyPolicyView(),
    '/terms-and-conditions': (context) => const TermsAndConditionsView(),
  };
}
