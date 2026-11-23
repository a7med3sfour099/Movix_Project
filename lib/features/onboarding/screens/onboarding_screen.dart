import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:movixapp/features/onboarding/data/onboarding_data.dart';
import 'package:movixapp/features/onboarding/data/onboarding_prefs.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_dots.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_page_layout.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_scene_1.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_scene_2.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_scene_3.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_scene_4.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  final _cubit = OnboardingCubit();

  /// The real movies for the illustrations (null until loaded, or if it fails).
  OnboardingData? _data;

  @override
  void initState() {
    super.initState();
    OnboardingData.load().then((data) {
      if (mounted) setState(() => _data = data);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _cubit.close();
    super.dispose();
  }

  /// Remember that the user saw the onboarding, then go to Login.
  Future<void> _finish() async {
    await OnboardingPrefs.markSeen();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _next() {
    if (_cubit.isLast) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  List<_PageData> _buildPages() => [
        _PageData(
          illustration: OnboardingScene1(data: _data),
          tagline: 'Your taste. Your universe.',
          title: 'Discover what you love',
          description:
              'Movies or series? Pick your genres and languages. We\'ll find the stories that feel like you.',
        ),
        _PageData(
          illustration: OnboardingScene2(data: _data),
          tagline: 'Search less. Watch more.',
          title: 'Find your next movie',
          description:
              'Search movies, series, and actors in one place. Filter by type, jump into any title, and meet the people behind it.',
        ),
        _PageData(
          illustration: OnboardingScene3(data: _data),
          tagline: 'Every story, in detail.',
          title: 'Explore every story',
          description:
              'Open any title to see its story, cast, ratings, and release details. Everything you need to pick your next watch, all in one place.',
        ),
        _PageData(
          illustration: OnboardingScene4(data: _data),
          tagline: 'Your stories. Always with you.',
          title: 'Keep your movie world with you',
          description:
              'Save the ones you love, rate what you\'ve watched, and never miss what\'s next. Your lists come along even offline.',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: _cubit.pageChanged,
                itemCount: OnboardingCubit.pageCount,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return OnboardingPageLayout(
                    illustration: page.illustration,
                    tagline: page.tagline,
                    title: page.title,
                    description: page.description,
                  );
                },
              ),
            ),
            BlocBuilder<OnboardingCubit, int>(
              bloc: _cubit,
              builder: (context, current) {
                return Column(
                  children: [
                    OnboardingDots(
                      count: OnboardingCubit.pageCount,
                      current: current,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: CustomElevatedbutton(
                        text: _cubit.isLast ? 'Get Started' : 'Next',
                        size: 16,
                        onPressed: _next,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Row(
        children: [
          Image.asset('assets/images/logo.png', width: 28, height: 28),
          const SizedBox(width: 8),
          const Text(
            'MOVIX',
            style: TextStyle(
              fontFamily: 'JakartaSans',
              color: AppColors.primary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: _finish,
            child: Text(
              'Skip',
              style: TextStyle(
                fontFamily: 'JakartaSans',
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageData {
  final Widget illustration;
  final String tagline;
  final String title;
  final String description;

  const _PageData({
    required this.illustration,
    required this.tagline,
    required this.title,
    required this.description,
  });
}
