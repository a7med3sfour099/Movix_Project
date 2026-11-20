import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:movixapp/features/actors/screens/actor_profile_screen.dart';
import 'package:movixapp/features/details/screens/media_details_screen.dart';
import 'package:movixapp/features/home/widgets/home_header.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';
import 'package:movixapp/features/search/data/search_result.dart';

/// One row of the search results (poster, type badge, title, details, arrow).
class SearchResultTile extends StatelessWidget {
  final SearchResult result;

  const SearchResultTile({super.key, required this.result});

  String get _badge {
    if (result.type == 'tv') return 'TV Show';
    if (result.type == 'person') return result.gender == 1 ? 'Actress' : 'Actor';
    return 'Movie';
  }

  String get _subtitle {
    if (result.isPerson) return result.knownFor.take(3).join(', ');
    final genres = result.genreIds
        .map((id) => MoviesApi.genres[id])
        .whereType<String>()
        .take(2);
    return genres.join(' \u2022 ');
  }

  void _open(BuildContext context) {
    final Widget screen = result.isPerson
        ? ActorProfileScreen(id: result.id)
        : MediaDetailsScreen(id: result.id, type: result.type);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final subtitle = _subtitle;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _open(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: HomeHeader.darkColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _poster(),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: HomeHeader.greenColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _badge,
                      style: const TextStyle(
                        color: HomeHeader.greenColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    result.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF9AA8A2),
                        fontSize: 12,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  _details(),
                ],
              ),
            ),
            const Icon(
              Symbols.chevron_right,
              color: Color(0xFF9AA8A2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _details() {
    if (result.isPerson) {
      return Text(
        result.department,
        style: const TextStyle(color: Color(0xFF7C8B85), fontSize: 11),
      );
    }
    return Row(
      children: [
        if (result.year != null)
          Text(
            '${result.year}',
            style: const TextStyle(color: Color(0xFF7C8B85), fontSize: 11),
          ),
        if (result.year != null && result.rating > 0)
          const Text(
            '  \u2022  ',
            style: TextStyle(color: Color(0xFF7C8B85), fontSize: 11),
          ),
        if (result.rating > 0) ...[
          const Icon(Symbols.star, size: 13, color: HomeHeader.greenColor),
          const SizedBox(width: 3),
          Text(
            result.rating.toStringAsFixed(1),
            style: const TextStyle(
              color: HomeHeader.greenColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }

  Widget _poster() {
    const width = 56.0;
    const height = 80.0;
    final placeholder = Container(
      width: width,
      height: height,
      color: const Color(0xFF1B2823),
      child: Icon(
        result.isPerson ? Symbols.person : Symbols.movie,
        color: const Color(0xFF5C6B65),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: result.image == null
          ? placeholder
          : Image.network(
              result.image!,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => placeholder,
            ),
    );
  }
}
