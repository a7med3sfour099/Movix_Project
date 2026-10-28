import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movixapp/core/routes/app_routes.dart';
import 'package:movixapp/core/routes/nav_key.dart';
import 'package:movixapp/core/services/app_link_service.dart';
import 'package:movixapp/core/services/app_navigation_service.dart';
import 'package:movixapp/features/auth/views/login_view.dart';
import 'package:movixapp/firebase_options.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final AppLinkService appLinkService = AppLinkService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await appLinkService.init(
    onPasswordResetLink: AppNavigationService.instance.handlePasswordResetLink,
  );
  runApp(const MyApp());

  WidgetsBinding.instance.addPostFrameCallback((_) {
    AppNavigationService.instance.handlePendingPasswordResetLink();
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
          navigatorKey: NavKey.navigatorKey,
          home: const LoginView(),
          routes: AppRoutes.routes,
        );
      },
    );
  }
}
