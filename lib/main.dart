import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movixapp/features/auth/views/login_view.dart';
import 'package:movixapp/firebase_options.dart';
import 'package:movixapp/features/auth/views/signup_view.dart';
import 'package:movixapp/features/auth/views/change_password_view.dart';
import 'package:movixapp/features/settings/views/settings_view.dart';
import 'package:movixapp/features/auth/views/forget_password.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: SignupView(),
      home: LoginView(),
      //home: changePassword(),
      //home: ForgetPassword(),
      //home: SettingsView(),
    );
  }
}
