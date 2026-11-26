import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/onboarding/data/onboarding_data.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_parts.dart';

const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// Page 4: favorites, watchlist, calendar and rating cards.
class OnboardingScene4 extends StatelessWidget {
  final OnboardingData? data;

  const OnboardingScene4({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final movie = data?.featured;
    final trending = data?.trending ?? [];
    final right = trending.isNotEmpty ? trending[0] : null;
    final left = trending.length > 1 ? trending[1] : null;
    // A different movie for the calendar, so it does not repeat a poster.
    final calendar = trending.length > 2
        ? trending[2]
        : (trending.length > 1 ? trending[1] : null);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.4),
            radius: 1.0,
            colors: [Color(0xFF16352E), Color(0xFF0C1514)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final h = c.maxHeight;
            final heightCenter = h * 0.55;
            final heightSide = h * 0.47;
            final widthCenter = heightCenter * 2 / 3;

            return Stack(
              children: [
                // Back posters first, the center one is on top of them.
                Positioned(
                  left: w * 0.03,
                  top: h * 0.07,
                  width: heightSide * 2 / 3,
                  height: heightSide,
                  child: Transform.rotate(
                    angle: -math.pi / 22,
                    child: _PosterCard(
                      url: left?.image,
                      title: '',
                      label: 'Watched',
                      icon: Icons.check_circle_outline,
                    ),
                  ),
                ),
                Positioned(
                  right: w * 0.03,
                  top: h * 0.07,
                  width: heightSide * 2 / 3,
                  height: heightSide,
                  child: Transform.rotate(
                    angle: math.pi / 22,
                    child: _PosterCard(
                      url: right?.image,
                      title: '',
                      label: 'Watchlist',
                      icon: Icons.bookmark_border,
                      chipAtRight: true,
                    ),
                  ),
                ),
                Positioned(
                  left: (w - widthCenter) / 2,
                  top: h * 0.02,
                  width: widthCenter,
                  height: heightCenter,
                  child: _PosterCard(
                    url: movie?.poster,
                    title: movie?.title ?? '',
                    label: 'Favorites',
                    icon: Icons.favorite_border,
                  ),
                ),
                if (calendar != null)
                  Positioned(
                    left: w * 0.08,
                    right: w * 0.08,
                    top: h * 0.56,
                    child: _calendarCard(calendar),
                  ),
                Positioned(
                  left: w * 0.06,
                  right: w * 0.06,
                  bottom: h * 0.04,
                  child: _rateCard(movie?.title ?? ''),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _calendarCard(MediaItem item) {
    final date = DateTime.tryParse(item.date) ?? DateTime.now();
    final month = _months[date.month - 1];
    final day = date.day.toString().padLeft(2, '0');
    final verb = date.isBefore(DateTime.now()) ? 'Released' : 'Premieres';
    final type = item.type == 'tv' ? 'Series' : 'Movie';

    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  month.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'JakartaSans',
                    color: AppColors.background,
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  day,
                  style: const TextStyle(
                    fontFamily: 'JakartaSans',
                    color: AppColors.background,
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ON YOUR CALENDAR',
                  style: TextStyle(
                    fontFamily: 'JakartaSans',
                    color: AppColors.primary,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'JakartaSans',
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '$type \u00b7 $verb $month $day',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'JakartaSans',
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateCard(String title) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rate this movie',
            style: TextStyle(
              fontFamily: 'JakartaSans',
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 26, color: AppColors.primary),
                Icon(Icons.star, size: 26, color: AppColors.primary),
                Icon(Icons.star, size: 26, color: AppColors.primary),
                Icon(Icons.star, size: 26, color: AppColors.primary),
                Icon(Icons.star_border, size: 26, color: AppColors.primary),
              ],
            ),
          ),
          if (title.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'JakartaSans',
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// A poster with a small label (Favorites / Watchlist) and the title on it.
class _PosterCard extends StatelessWidget {
  final String? url;
  final String title;
  final String label;
  final IconData icon;

  /// Puts the label in the top right corner (for the poster on the right,
  /// because its left side is hidden behind the center poster).
  final bool chipAtRight;

  const _PosterCard({
    required this.url,
    required this.title,
    required this.label,
    required this.icon,
    this.chipAtRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        PosterImage(url: url),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.75),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 8,
          left: chipAtRight ? null : 8,
          right: chipAtRight ? 8 : null,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 11, color: Colors.white),
                const SizedBox(width: 3),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'JakartaSans',
                    color: Colors.white,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (title.isNotEmpty)
          Positioned(
          left: 8,
          right: 8,
          bottom: 8,
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'JakartaSans',
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
