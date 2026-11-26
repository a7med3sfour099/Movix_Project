import 'package:dio/dio.dart';
import 'package:movixapp/core/network/dio_client.dart';
import '../../home/data/movie_details.dart';
import 'package:movixapp/features/home/data/media_item.dart';

class MoviesApi {
  final Dio dio = DioClient.instance.dio;
  static Map<int, String> genres = {};

  Future<void> loadGenres() async {
    if (genres.isNotEmpty) return;
    for (final type in ['movie', 'tv']) {
      final response = await dio.get('/genre/$type/list');
      for (final genre in response.data['genres']) {
        genres[genre['id']] = genre['name'];
      }
    }
  }

  Future<Movie> getMovie(int id) async {
    final response = await dio.get(
      '/movie/$id',
      queryParameters: {'append_to_response': 'videos'},
    );
    return Movie.fromJson(response.data);
  }

  Future<Movie> findMovie(String name, String year) async {
    final response = await dio.get(
      '/search/movie',
      queryParameters: {'query': name, 'year': year},
    );
    final results = response.data['results'] as List;
    final id = results.first['id'];
    return getMovie(id);
  }

  Future<List<MediaItem>> getList(
      String path,
      String type, {
        Map<String, dynamic>? params,
        int pages = 3,
      }) async {
    await loadGenres();

    final responses = await Future.wait(
      List.generate(
        pages,
            (i) => dio.get(
          path,
          queryParameters: {
            ...?params,
            'page': i + 1,
            'include_adult': false,
          },
        ),
      ),
    );

    final seen = <int>{};
    final items = <MediaItem>[];
    for (final response in responses) {
      for (final raw in response.data['results'] as List) {
        if (type != 'person' && raw['media_type'] == 'person') continue;
        if ((raw['poster_path'] ?? raw['profile_path']) == null) continue;
        if (!seen.add(raw['id'] as int)) continue;
        items.add(MediaItem.fromJson(raw, type));
      }
    }
    return items;
  }

  /// One page of results, for lists that load more while scrolling.
  Future<({List<MediaItem> items, bool hasMore})> getPage(
    String path,
    String type, {
    int page = 1,
    Map<String, dynamic>? params,
  }) async {
    await loadGenres();
    final response = await dio.get(
      path,
      queryParameters: {...?params, 'page': page, 'include_adult': false},
    );
    final items = <MediaItem>[];
    for (final raw in response.data['results'] as List) {
      if (raw['media_type'] == 'person') continue;
      if (raw['poster_path'] == null) continue;
      items.add(MediaItem.fromJson(raw, type));
    }
    final totalPages = (response.data['total_pages'] as int?) ?? 1;
    // TMDB only serves the first 500 pages.
    return (items: items, hasMore: page < totalPages && page < 500);
  }

  Future<Map<int, String>> getGenresFor(String type) async {
    final response = await dio.get('/genre/$type/list');
    return {
      for (final g in response.data['genres'] as List)
        g['id'] as int: g['name'] as String,
    };
  }

  Future<List<MediaItem>> getTrending(String window) =>
      getList('/trending/all/$window', 'movie');

  static Map<String, dynamic> upcomingParams() {
    final now = DateTime.now();
    final end = now.add(const Duration(days: 270));
    String fmt(DateTime d) => d.toIso8601String().substring(0, 10);
    return {
      'primary_release_date.gte': fmt(now),
      'primary_release_date.lte': fmt(end),
      'with_release_type': '2|3',
      'sort_by': 'popularity.desc',
    };
  }

  Future<List<MediaItem>> getUpcoming() async {
    final items = await getList(
      '/discover/movie',
      'movie',
      params: upcomingParams(),
      pages: 4,
    );
    items.sort((a, b) => a.date.compareTo(b.date));
    return items;
  }

  Future<int> getCount(String path) async {
    final response = await dio.get(path);
    return response.data['total_results'];
  }
}