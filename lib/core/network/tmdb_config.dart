class TmdbConfig {
  TmdbConfig._();

  static const String baseUrl = 'https://api.themoviedb.org/3/';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String language = 'en-US';

  static String posterUrl(String? path, {String size = 'w500'}) {
    if (path == null || path.isEmpty) return '';
    return '$imageBaseUrl/$size$path';
  }
}