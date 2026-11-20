import 'package:movixapp/core/api_config.dart';
import 'package:movixapp/features/movies/data/media_item.dart';

class PersonDetails {
  final int id;
  final String name;
  final String? birthday;
  final String? deathday;
  final String birthplace;
  final String biography;
  final String? image;
  final double popularity;
  final List<String> aliases;
  final List<String> photos;
  final List<MediaItem> movies;
  final List<MediaItem> tvShows;

  const PersonDetails({
    required this.id,
    required this.name,
    required this.birthday,
    required this.deathday,
    required this.birthplace,
    required this.biography,
    required this.image,
    required this.popularity,
    required this.aliases,
    required this.photos,
    required this.movies,
    required this.tvShows,
  });

  factory PersonDetails.fromJson(Map<String, dynamic> json) {
    final profile = json['profile_path'];

    final photos = <String>[];
    for (final p in (json['images']?['profiles'] as List? ?? [])) {
      photos.add('${ApiConfig.imageBaseUrl}/w500${p['file_path']}');
    }

    final movies = <MediaItem>[];
    final tvShows = <MediaItem>[];
    _readCredits(json['combined_credits']?['cast'] as List? ?? [], movies, tvShows);

    return PersonDetails(
      id: json['id'] as int,
      name: json['name'] ?? '',
      birthday: json['birthday'],
      deathday: json['deathday'],
      birthplace: _shortPlace(json['place_of_birth'] ?? ''),
      biography: (json['biography'] ?? '').toString().trim(),
      image: profile == null ? null : '${ApiConfig.imageBaseUrl}/h632$profile',
      popularity: ((json['popularity'] ?? 0) as num).toDouble(),
      aliases: [for (final a in (json['also_known_as'] as List? ?? [])) '$a'],
      photos: photos,
      movies: movies,
      tvShows: tvShows,
    );
  }
// Sorted by popularity, without duplicates or talk shows/news appearances
  static void _readCredits(
    List credits,
    List<MediaItem> movies,
    List<MediaItem> tvShows,
  ) {
    const hidden = {10767, 10763}; // Talk, News
    final list = credits
        .where((c) => c['poster_path'] != null)
        .where((c) => !(c['genre_ids'] as List? ?? []).any(hidden.contains))
        .toList()
      ..sort((a, b) => ((b['popularity'] ?? 0) as num)
          .compareTo((a['popularity'] ?? 0) as num));

    final seen = <String>{};
    for (final raw in list) {
      final type = raw['media_type'] == 'tv' ? 'tv' : 'movie';
      if (!seen.add('$type-${raw['id']}')) continue;
      (type == 'tv' ? tvShows : movies).add(MediaItem.fromJson(raw, type));
    }
  }

// Removes the state from the location when it's redundant
  static String _shortPlace(String place) {
    final parts = place.split(',').map((e) => e.trim()).toList();
    return parts.length <= 2 ? place : '${parts.first}, ${parts.last}';
  }
}
