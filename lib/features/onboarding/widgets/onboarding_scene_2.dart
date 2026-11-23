import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/details/data/media_details.dart';
import 'package:movixapp/features/movies/data/media_item.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';
import 'package:movixapp/features/onboarding/data/onboarding_data.dart';
import 'package:movixapp/features/onboarding/widgets/onboarding_parts.dart';

/// Page 2: search bar, the featured movie, its cast and "Trending now".
class OnboardingScene2 extends StatelessWidget {
  final OnboardingData? data;

  const OnboardingScene2({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final movie = data?.featured;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        fit: StackFit.expand,
        children: [
          PosterImage(url: movie?.backdrop, radius: 0),
          // Dark fade so the texts are easy to read.
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  const Color(0xFF0C1514).withValues(alpha: 0.96),
                ],
                stops: const [0.0, 0.8],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _searchBar(),
                if (movie != null)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, c) {
                        // Scales the content down on small screens
                        // so it never overflows.
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.bottomLeft,
                          child: SizedBox(
                            width: c.maxWidth,
                            child: _details(movie),
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

  Widget _searchBar() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          const Icon(Symbols.search, size: 18, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(
            'Search movies, series, actors',
            style: TextStyle(
              fontFamily: 'JakartaSans',
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _details(MediaDetails movie) {
    final match = (movie.rawRating * 10).round();
    final meta = [
      movie.year,
      if (movie.genres.isNotEmpty) movie.genres.first,
      movie.runtime,
    ].where((p) => p.isNotEmpty).join(' \u00b7 ');
    final cast = movie.cast.isEmpty ? null : movie.cast.first;
    final trending = data?.trending ?? [];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Symbols.auto_awesome, size: 12, color: AppColors.primary),
            const SizedBox(width: 5),
            Text(
              'FOR YOU \u00b7 $match% MATCH',
              style: const TextStyle(
                fontFamily: 'JakartaSans',
                color: AppColors.primary,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          movie.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'JakartaSans',
            color: Colors.white,
            fontSize: 26,
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
        if (cast != null) ...[
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  height: 36,
                  child: PosterImage(url: cast.image, radius: 18),
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
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (cast.character.isNotEmpty)
                        Text(
                          'Plays ${cast.character}',
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
                  'Cast & story',
                  style: TextStyle(
                    fontFamily: 'JakartaSans',
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(Symbols.north_east, size: 12, color: AppColors.primary),
              ],
            ),
          ),
        ],
        if (trending.length >= 2) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Trending now',
                        style: TextStyle(
                          fontFamily: 'JakartaSans',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Text(
                      'New releases',
                      style: TextStyle(
                        fontFamily: 'JakartaSans',
                        color: AppColors.primary,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Symbols.north_east,
                      size: 11,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _TrendingItem(item: trending[0], rank: 2)),
                    const SizedBox(width: 10),
                    Expanded(child: _TrendingItem(item: trending[1], rank: 3)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _TrendingItem extends StatelessWidget {
  final MediaItem item;
  final int rank;

  const _TrendingItem({required this.item, required this.rank});

  @override
  Widget build(BuildContext context) {
    final type = item.type == 'tv' ? 'Series' : 'Movie';
    final genre = MoviesApi.genres[item.genreId];
    final subtitle = genre == null ? type : '$type \u00b7 $genre';

    return Row(
      children: [
        SizedBox(
          width: 30,
          height: 42,
          child: PosterImage(url: item.image, radius: 6),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'JakartaSans',
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'JakartaSans',
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 9,
                ),
              ),
              Text(
                '#$rank THIS WEEK',
                style: const TextStyle(
                  fontFamily: 'JakartaSans',
                  color: AppColors.primary,
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
