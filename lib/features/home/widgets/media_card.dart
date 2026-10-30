import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/movies/data/media_item.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';

class MediaCard extends StatelessWidget {
  final MediaItem item;
  final bool upcoming;

  const MediaCard({super.key, required this.item, this.upcoming = false});

  @override
  Widget build(BuildContext context) {
    final typeName = item.type == 'tv' ? 'TV' : 'MOVIE';
    final greenLine = [
      typeName,
      if (item.year.isNotEmpty) item.year,
    ].join(' \u2022 ');
    final genre = MoviesApi.genres[item.genreId] ?? '';

    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(
              aspectRatio: 2 / 3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  cardImage(item.image),
                  if (upcoming) upcomingOverlay(),
                  if (genre.isNotEmpty)
                    Positioned(top: 8, left: 8, child: genreLabel(genre)),
                  Positioned(top: 8, right: 8, child: ratingBadge(item.rating)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            greenLine,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: HomeHeader.greenColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Symbols.chevron_right, size: 16, color: Color(0xFFB4C2BC)),
            ],
          ),
        ],
      ),
    );
  }

  Widget cardImage(String? url) {
    const darkBackground = ColoredBox(color: Color(0xFF0F1F1A));
    if (url == null) return darkBackground;
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stack) => darkBackground,
    );
  }

  Widget upcomingOverlay() {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0x99000000)),
        Center(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xCC0B1512),
              border: Border.symmetric(
                horizontal: BorderSide(color: HomeHeader.greenColor, width: 2),
              ),
            ),
            child: const Text(
              'COMING SOON',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HomeHeader.greenColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget genreLabel(String genre) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 80),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0x990F1F1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        genre,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget ratingBadge(String rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0x990F1F1A),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Symbols.star, size: 12, fill: 1, color: HomeHeader.greenColor),
          const SizedBox(width: 3),
          Text(
            rating,
            style: const TextStyle(
              color: HomeHeader.greenColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}