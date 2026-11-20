import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/Widgets/media_poster.dart';
import 'package:movixapp/features/actors/screens/actor_profile_screen.dart';
import 'package:movixapp/features/details/screens/media_details_screen.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/movies/data/media_item.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';

class MediaCard extends StatelessWidget {
  final MediaItem item;

  // Shows the COMING SOON style Future releases get it automatically
  final bool upcoming;
  final double width;

// Opens the item's details screen by default
  final VoidCallback? onTap;

  const MediaCard({
    super.key,
    required this.item,
    this.upcoming = false,
    this.width = 150,
    this.onTap,
  });

  void _open(BuildContext context) {
    final Widget screen = item.type == 'person'
        ? ActorProfileScreen(id: item.id)
        : MediaDetailsScreen(id: item.id, type: item.type);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final typeName = item.type == 'tv' ? 'TV' : 'MOVIE';
    final greenLine = [
      typeName,
      if (item.year.isNotEmpty) item.year,
    ].join(' \u2022 ');
    final genre = MoviesApi.genres[item.genreId] ?? '';
    final banner = (upcoming || MediaPoster.isUnreleased(item.date))
        ? MediaPoster.bannerFor(item.date)
        : null;

    return GestureDetector(
      onTap: onTap ?? () => _open(context),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MediaPoster(
              url: item.image,
              bannerText: banner,
              overlays: [
                if (genre.isNotEmpty)
                  Positioned(top: 8, left: 8, child: genreLabel(genre)),
                Positioned(top: 8, right: 8, child: ratingBadge(item.rating)),
              ],
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
      ),
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
