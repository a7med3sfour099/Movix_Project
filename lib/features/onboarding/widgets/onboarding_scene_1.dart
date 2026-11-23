import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/onboarding/data/onboarding_data.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_parts.dart';

/// Page 1: two tilted posters and the "Set your scene" card.
class OnboardingScene1 extends StatelessWidget {
  final OnboardingData? data;

  const OnboardingScene1({super.key, required this.data});

  /// Poster of the n-th trending movie (null if it is not loaded).
  String? _trendingPoster(int index) {
    final list = data?.trending ?? [];
    return index < list.length ? list[index].image : null;
  }

  @override
  Widget build(BuildContext context) {
    // Center: the main movie. Sides: two other trending movies.
    final center = data?.featured.poster;
    final left = _trendingPoster(1);
    final right = _trendingPoster(0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.3),
            radius: 1.0,
            colors: [Color(0xFF16352E), Color(0xFF0C1514)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;
            // Poster sizes follow the height, so they never overflow.
            final heightCenter = h * 0.54;
            final heightSide = h * 0.45;
            final widthCenter = heightCenter * 2 / 3;

            return Stack(
              children: [
                // Back posters first, so the center one is on top of them.
                Positioned(
                  left: w * 0.03,
                  top: h * 0.07,
                  width: heightSide * 2 / 3,
                  height: heightSide,
                  child: Transform.rotate(
                    angle: -math.pi / 22,
                    child: PosterImage(url: left),
                  ),
                ),
                Positioned(
                  right: w * 0.03,
                  top: h * 0.07,
                  width: heightSide * 2 / 3,
                  height: heightSide,
                  child: Transform.rotate(
                    angle: math.pi / 22,
                    child: PosterImage(url: right),
                  ),
                ),
                Positioned(
                  left: (w - widthCenter) / 2,
                  top: h * 0.02,
                  width: widthCenter,
                  height: heightCenter,
                  child: PosterImage(url: center),
                ),
                Positioned(
                  left: w * 0.06,
                  right: w * 0.06,
                  bottom: h * 0.05,
                  child: _sceneCard(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _sceneCard() {
    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Set your scene.',
                  style: TextStyle(
                    fontFamily: 'JakartaSans',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(
                Symbols.auto_awesome,
                color: AppColors.primary.withValues(alpha: 0.8),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'pick your type and genres.',
            style: TextStyle(
              fontFamily: 'JakartaSans',
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _SceneChip(label: 'Movies', icon: Symbols.movie),
              _SceneChip(label: 'Series', icon: Symbols.tv),
              _SceneChip(label: 'Sci-fi'),
              _SceneChip(label: 'Mystery'),
              _SceneChip(label: 'Romance'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Symbols.tune, size: 14, color: AppColors.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Trending, top-rated, and upcoming, made for you',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'JakartaSans',
                    color: AppColors.primary.withValues(alpha: 0.9),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SceneChip extends StatelessWidget {
  final String label;
  final IconData? icon;

  const _SceneChip({required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'JakartaSans',
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
