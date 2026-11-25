import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/features/home/cubit/hero_cubit.dart';
import 'package:movixapp/features/home/cubit/hero_state.dart';
import 'package:movixapp/features/home/widgets/hero_card.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HeroCubit()..loadMovie(),
      child: BlocBuilder<HeroCubit, HeroState>(
        builder: (context, state) {
          final cubit = context.read<HeroCubit>();
          return switch (state) {
            HeroInitial() ||
            HeroLoading() => messageBox(const CircularProgressIndicator()),
            HeroLoaded(:final movie) => HeroCard(movie: movie),
            HeroFailure(:final message) => messageBox(
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(text: message, color: Colors.white),
                  TextButton(
                    onPressed: () => cubit.loadMovie(),
                    child: const Text('Try again'),
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }

  Widget messageBox(Widget message) {
    return SizedBox(height: 260, child: Center(child: message));
  }
}
