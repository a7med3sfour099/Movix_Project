import 'package:movixapp/core/api_config.dart';
import 'package:movixapp/core/rating_calc.dart';

class MediaItem {
  final int id;
  final String title;
  final String year;
  final String date;
  final String type;
  final String rating;
  final int? genreId;
  final String? image;

  MediaItem({
    required this.id,
    required this.title,
    required this.year,
    required this.date,
    required this.type,
    required this.rating,
    this.genreId,
    this.image,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json, String defaultType) {
    final type = json['media_type'] ?? defaultType;

    final date = json['release_date'] ?? json['first_air_date'] ?? '';
    final year = date.length >= 4 ? date.substring(0, 4) : '';

    final genres = json['genre_ids'] as List? ?? [];
    final genreId = genres.isEmpty ? null : genres[0] as int;

    final path = json['poster_path'] ?? json['profile_path'];
    final image = path == null ? null : '${ApiConfig.imageBaseUrl}/w342$path';

    return MediaItem(
      id: json['id'],
      title: json['title'] ?? json['name'] ?? '',
      year: year,
      date: date,
      type: type,
      rating: formatRating((json['vote_average'] ?? 0).toDouble()),
      genreId: genreId,
      image: image,
    );
  }
}