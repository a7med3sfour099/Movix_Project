import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/details/data/media_details.dart';
import 'package:movixapp/features/onboarding/data/onboarding_data.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_parts.dart';

/// Page 3: "About the film" with the story, the cast and the tabs.
class OnboardingScene3 extends StatelessWidget {
  final OnboardingData? data;

  const OnboardingScene3({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final movie = data?.featured;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PosterImage(url: movie?.backdrop, radius: 0),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.2),
                  const Color(0xFF0C1514).withValues(alpha: 0.96),
                ],
                stops: const [0.0, 0.85],
              ),
            ),
          ),
          if (movie != null)
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(movie),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, c) {
                        // Scales the card down on small screens.
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            width: c.maxWidth,
                            child: _aboutCard(movie),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _header(MediaDetails movie) {
    final meta = [
      movie.year,
      if (movie.genres.isNotEmpty) movie.genres.first,
      movie.runtime,
    ].where((p) => p.isNotEmpty).join(' \u00b7 ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ABOUT THE FILM',
          style: TextStyle(
            fontFamily: 'JakartaSans',
            color: AppColors.primary,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          movie.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'JakartaSans',
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              meta,
              style: TextStyle(
                fontFamily: 'JakartaSans',
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(Symbols.star, size: 13, color: AppColors.primary),
            const SizedBox(width: 3),
            Text(
              movie.rating,
              style: const TextStyle(
                fontFamily: 'JakartaSans',
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _aboutCard(MediaDetails movie) {
    final cast = movie.cast.isEmpty ? null : movie.cast.first;

    return GlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'About',
                  style: TextStyle(
                    fontFamily: 'JakartaSans',
                    color: Colors.white,
                    fontSize: 20,
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
          if (movie.overview.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              movie.overview,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'JakartaSans',
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ],
          if (cast != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: PosterImage(url: cast.image, radius: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cast.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'JakartaSans',
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (cast.character.isNotEmpty)
                          Text(
                            'as ${cast.character}',
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
                  const Text(
                    'Full cast',
                    style: TextStyle(
                      fontFamily: 'JakartaSans',
                      color: AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(
                    Symbols.north_east,
                    size: 12,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),
          const Row(
            children: [
              _Tab(label: 'Cast', selected: true),
              SizedBox(width: 8),
              _Tab(label: 'Ratings'),
              SizedBox(width: 8),
              _Tab(label: 'Details'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool selected;

  const _Tab({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withValues(alpha: 0.15)
            : Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : Colors.white.withValues(alpha: 0.25),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'JakartaSans',
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
