import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/Widgets/custom_elevated_button.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/onboarding/cubit/onboarding_cubit.dart';
import 'package:movixapp/features/onboarding/data/onboarding_prefs.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_dots.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_page_layout.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_scene_1.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_scene_2.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_scene_3.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_scene_4.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _finish(BuildContext context) async {
    await OnboardingPrefs.markSeen();

    if (!context.mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  List<Widget> _buildPages(OnboardingState state) {
    final data = state.data;

    return [
      OnboardingPageLayout(
        illustration: OnboardingScene1(data: data),
        tagline: 'Your taste. Your universe.',
        title: 'Discover what you love',
        description:
        'Movies or series? Pick your genres and languages. We\'ll find the stories that feel like you.',
      ),
      OnboardingPageLayout(
        illustration: OnboardingScene2(data: data),
        tagline: 'Search less. Watch more.',
        title: 'Find your next movie',
        description:
        'Search movies, series, and actors in one place. Filter by type, jump into any title, and meet the people behind it.',
      ),
      OnboardingPageLayout(
        illustration: OnboardingScene3(data: data),
        tagline: 'Every story, in detail.',
        title: 'Explore every story',
        description:
        'Open any title to see its story, cast, ratings, and release details. Everything you need to pick your next watch, all in one place.',
      ),
      OnboardingPageLayout(
        illustration: OnboardingScene4(data: data),
        tagline: 'Your stories. Always with you.',
        title: 'Keep your movie world with you',
        description:
        'Save the ones you love, rate what you\'ve watched, and never miss what\'s next. Your lists come along even offline.',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<OnboardingCubit>();

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: BlocBuilder<OnboardingCubit, OnboardingState>(
                builder: (context, state) {
                  final pages = _buildPages(state);

                  return Column(
                    children: [
                      _topBar(context),

                      Expanded(
                        child: PageView(
                          controller: cubit.pageController,
                          onPageChanged: cubit.pageChanged,
                          children: pages,
                        ),
                      ),

                      OnboardingDots(
                        count: OnboardingCubit.pageCount,
                        current: state.currentPage,
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: CustomElevatedbutton(
                          text: cubit.isLastPage
                              ? 'Get Started'
                              : 'Next',
                          size: 16,
                          onPressed: cubit.isLastPage
                              ? () => _finish(context)
                              : cubit.nextPage,
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _topBar(BuildContext context) {
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
            onPressed: () => _finish(context),
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