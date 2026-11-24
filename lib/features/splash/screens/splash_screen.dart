import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movixapp/core/constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final Widget next;

  const SplashScreen({super.key, required this.next});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _finished = false;

  void _onLoaded(LottieComposition composition) {
    Future.delayed(composition.duration, () {
      if (mounted) setState(() => _finished = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _finished
          ? widget.next
          : Scaffold(
        key: const ValueKey('splash'),
        backgroundColor: AppColors.background,
        body: SizedBox.expand(
          child: Lottie.asset(
            'assets/lottie/splash.json',
            fit: BoxFit.cover,
            repeat: false,
            onLoaded: _onLoaded,
          ),
        ),
      ),
    );
  }
}