import 'package:movixapp/core/api_config.dart';
import 'package:movixapp/core/rating_calc.dart';

class Movie {
  final int id;
  final String title;
  final String story;
  final String year;
  final String genre;
  final String time;
  final String rating;
  final String? image;
  final String? trailer;

  Movie({
    required this.id,
    required this.title,
    required this.story,
    required this.year,
    required this.genre,
    required this.time,
    required this.rating,
    this.image,
    this.trailer,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    // date
    final date = json['release_date'] ?? '';
    final year = date.length >= 4 ? date.substring(0, 4) : '';

    // genre
    final genres = json['genres'] as List? ?? [];
    final genre = genres.isEmpty ? '' : genres[0]['name'];

    // time
    final minutes = json['runtime'] ?? 0;
    final time = minutes == 0 ? '' : '${minutes ~/ 60}h ${minutes % 60}m';

    // img
    final poster = json['poster_path'];
    final image = poster == null ? null : '${ApiConfig.imageBaseUrl}/w780$poster';
    // Trailer
    String? trailer;
    final videos = json['videos']?['results'] as List? ?? [];
    for (final video in videos) {
      if (video['type'] == 'Trailer') {
        trailer = video['key'];
        break;
      }
    }

    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      story: json['overview'] ?? '',
      year: year,
      genre: genre,
      time: time,
      rating: formatRating((json['vote_average'] ?? 0).toDouble()),
      image: image,
      trailer: trailer,
    );
  }
}
