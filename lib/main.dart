import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/bottom_bar_cubit.dart';
import 'package:movixapp/core/routes/app_routes.dart';
import 'package:movixapp/core/routes/nav_key.dart';
import 'package:movixapp/core/services/app_link_service.dart';
import 'package:movixapp/core/services/app_navigation_service.dart';
import 'package:movixapp/features/auth/cubit/auth_cubit.dart';
import 'package:movixapp/features/auth/views/login_view.dart';
import 'package:movixapp/features/home/cubit/home_tab_cubit.dart';
import 'package:movixapp/features/home/screens/home_screen.dart';
import 'package:movixapp/features/onboarding/data/onboarding_prefs.dart';
import 'package:movixapp/features/onboarding/screens/onboarding_screen.dart';
import 'package:movixapp/features/profile/cubit/profile_cubit.dart';
import 'package:movixapp/firebase_options.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:movixapp/features/Errors/offline_error_view.dart';
import 'package:movixapp/core/network/internet_cubit.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/splash/screens/splash_screen.dart';

final AppLinkService appLinkService = AppLinkService();

/// Page changes happen instantly, so there is no flash between screens.
class NoTransitionBuilder extends PageTransitionsBuilder {
  const NoTransitionBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await appLinkService.init(
    onPasswordResetLink: AppNavigationService.instance.handlePasswordResetLink,
  );
   const tmdbToken = String.fromEnvironment('TMDB_TOKEN');
  if (tmdbToken.isNotEmpty) {
  }

  const resetOnboarding = bool.fromEnvironment('RESET_ONBOARDING');
  if (resetOnboarding) await OnboardingPrefs.reset();

  final onboardingSeen = await OnboardingPrefs.isSeen();
  runApp(MyApp(onboardingSeen: onboardingSeen));

  WidgetsBinding.instance.addPostFrameCallback((_) {
    AppNavigationService.instance.handlePendingPasswordResetLink();
  });
}

class MyApp extends StatelessWidget {
  final bool onboardingSeen;

  const MyApp({super.key, required this.onboardingSeen});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ProfileCubit()..loadImage()),
        BlocProvider(create: (context) => HomeTabCubit()),
        BlocProvider(create: (context) => BottomBarCubit()),
        BlocProvider(create: (context) => InternetCubit(),),
      ],
      child: ResponsiveSizer(
        builder: (context, orientation, screenType) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorKey: NavKey.navigatorKey,
            theme: ThemeData(
                scaffoldBackgroundColor: AppColors.background,
              canvasColor: AppColors.background,
              pageTransitionsTheme: const PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: NoTransitionBuilder(),
                  TargetPlatform.iOS: NoTransitionBuilder(),
                },
              ),
            ),
             builder: (context, child) {
return BlocBuilder<InternetCubit, InternetState>(
  builder: (context, state) {
    return Stack(
      children: [
        child ?? const SizedBox.shrink(),
        if (!state.isConnected)
          const Positioned.fill(
            child: OfflineErrorView(),
          ),
      ],
    );
  },
);
 }, home: SplashScreen(
      next: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                final user = snapshot.data;
                if (user != null && user.emailVerified) {
                  return const HomeScreen();
                }
                if (!onboardingSeen) return const OnboardingScreen();
                return const LoginView();
              },
            ),
          ),
             routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
