import 'package:movixapp/core/constants/api_endpoints.dart';
import 'package:movixapp/core/network/api_service.dart';
import 'package:movixapp/core/network/result.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/home/data/movie_details.dart';

typedef PageResult = ({List<MediaItem> items, bool hasMore});

class MediaRepository {
  MediaRepository._();
  static final MediaRepository instance = MediaRepository._();

  final _api = ApiService.instance;

  Future<Result<List<MediaItem>>> getList(
    String path,
    String type, {
    Map<String, dynamic>? params,
    int pages = 1,
  }) async {
    if (pages <= 1) {
      return _api.get<List<MediaItem>>(
        path,
        query: {...?params, 'page': 1, 'include_adult': false},
        parser: (json) => _parseList(json, type),
      );
    }

    final all = <MediaItem>[];
    final seen = <int>{};
    const batchSize = 2;

    for (var start = 1; start <= pages; start += batchSize) {
      final end = (start + batchSize - 1).clamp(1, pages);
      final responses = await Future.wait([
        for (var p = start; p <= end; p++)
          _api.get<List<MediaItem>>(
            path,
            query: {...?params, 'page': p, 'include_adult': false},
            parser: (json) => _parseList(json, type),
          ),
      ]);

      for (final r in responses) {
        if (r case Failure(:final exception)) return Failure(exception);
        for (final item in (r as Success<List<MediaItem>>).data) {
          if (seen.add(item.id)) all.add(item);
        }
      }

      if (end < pages) {
        await Future.delayed(const Duration(milliseconds: 200));
      }
    }

    return Success(all);
  }

  Future<Result<PageResult>> getPage(
    String path,
    String type, {
    int page = 1,
    Map<String, dynamic>? params,
  }) async {
    final result = await _api.get<PageResult>(
      path,
      query: {...?params, 'page': page, 'include_adult': false},
      parser: (json) {
        final map = json as Map<String, dynamic>;
        final items = _parseList(json, type);
        final totalPages = (map['total_pages'] as int?) ?? 1;
        return (items: items, hasMore: page < totalPages && page < 500);
      },
    );
    return result;
  }

  Future<Result<Movie>> getMovie(int id) => _api.get(
    ApiEndpoints.movieDetails(id),
    query: {'append_to_response': 'videos'},
    parser: (json) => Movie.fromJson(json as Map<String, dynamic>),
  );

  Future<Result<Movie>> findMovie(String name, String year) async {
    final idResult = await _api.get<int>(
      ApiEndpoints.searchMovies,
      query: {'query': name, 'year': year},
      parser: (json) {
        final results = (json as Map<String, dynamic>)['results'] as List;
        if (results.isEmpty) throw StateError('Movie not found');
        return results.first['id'] as int;
      },
    );
    return switch (idResult) {
      Success(:final data) => getMovie(data),
      Failure(:final exception) => Failure(exception),
    };
  }

  Future<Result<List<MediaItem>>> getUpcoming() async {
    final result = await getList(
      ApiEndpoints.discoverMovies,
      'movie',
      params: upcomingParams(),
      pages: 1,
    );
    return switch (result) {
      Success(:final data) => Success(
        _onlyUnreleased(data)..sort((a, b) => a.date.compareTo(b.date)),
      ),
      Failure(:final exception) => Failure(exception),
    };
  }

  /// One page of the full Upcoming list ("See More").
  /// Uses the same discover query as the home section, never movie/upcoming,
  /// because that endpoint also returns movies that are already out.
  Future<Result<PageResult>> getUpcomingPage(int page) async {
    final result = await getPage(
      ApiEndpoints.discoverMovies,
      'movie',
      page: page,
      params: upcomingParams(),
    );
    return switch (result) {
      Success(:final data) => Success((
        items: _onlyUnreleased(data.items),
        hasMore: data.hasMore,
      )),
      Failure(:final exception) => Failure(exception),
    };
  }

  /// Keeps only movies whose release date is today or later.
  /// A safety net: TMDB sometimes lists movies that are already released.
  List<MediaItem> _onlyUnreleased(List<MediaItem> items) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    return items
        .where((i) => i.date.isNotEmpty && i.date.compareTo(today) >= 0)
        .toList();
  }

  Future<Result<int>> getCount(String path, {Map<String, dynamic>? query}) =>
      _api.get<int>(
        path,
        query: query,
        parser: (json) {
          final map = json as Map<String, dynamic>;
          return (map['total_results'] as int?) ?? 0;
        },
      );

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

  List<MediaItem> _parseList(dynamic json, String type) {
    final results = (json as Map<String, dynamic>)['results'] as List;
    final items = <MediaItem>[];
    for (final raw in results) {
      if (type != 'person' && raw['media_type'] == 'person') continue;
      if ((raw['poster_path'] ?? raw['profile_path']) == null) continue;
      items.add(MediaItem.fromJson(raw as Map<String, dynamic>, type));
    }
    return items;
  }

Future<Result<List<MediaItem>>> getHistory({
  String? filter,
  int page = 1,
}) {
  if (filter == 'tv') {
    return getList(ApiEndpoints.popularTvShows, 'tv', pages: page);
  } else if (filter == 'movie') {
    return getList(ApiEndpoints.popularMovies, 'movie', pages: page);
  } else {
    return getList(ApiEndpoints.trendingAllWeek, 'all', pages: page);
  }
}
}
