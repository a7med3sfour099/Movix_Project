import 'package:dio/dio.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';
import 'package:movixapp/features/search/data/search_filters.dart';
import 'package:movixapp/features/search/data/search_result.dart';

class SearchApi {
  final MoviesApi _api;

  SearchApi([MoviesApi? api]) : _api = api ?? MoviesApi();

  /// Searches TMDB and returns up to [maxPages] pages (20 results each).
  /// TMDB cannot filter or sort search results, so that happens in the app.
  Future<List<SearchResult>> search(
    String query,
    SearchType type, {
    int maxPages = 5,
  }) async {
    await _api.loadGenres();

    final path = switch (type) {
      SearchType.all => '/search/multi',
      SearchType.movies => '/search/movie',
      SearchType.tv => '/search/tv',
    };
    final defaultType = type == SearchType.tv ? 'tv' : 'movie';

    Future<Response> page(int p) => _api.dio.get(
          path,
          queryParameters: {'query': query, 'page': p, 'include_adult': false},
        );

    final first = await page(1);
    final totalPages = (first.data['total_pages'] as int?) ?? 1;
    final rest = await Future.wait([
      for (var p = 2; p <= totalPages && p <= maxPages; p++) page(p),
    ]);

    final seen = <String>{};
    final results = <SearchResult>[];
    for (final response in [first, ...rest]) {
      for (final raw in response.data['results'] as List) {
        final result = SearchResult.fromJson(raw, defaultType);
        if (result.type != 'movie' &&
            result.type != 'tv' &&
            result.type != 'person') {
          continue;
        }
        if (!seen.add('${result.type}-${result.id}')) continue;
        results.add(result);
      }
    }
    return results;
  }

  /// Movies / TV shows that match only the filters (no search text).
  /// Used when the user taps Apply in the filter sheet with an empty search box.
  Future<List<SearchResult>> discover(
    SearchFilters filters, {
    int maxPages = 5,
  }) async {
    await _api.loadGenres();

    final types = switch (filters.type) {
      SearchType.all => ['movie', 'tv'],
      SearchType.movies => ['movie'],
      SearchType.tv => ['tv'],
    };

    final lists = await Future.wait([
      for (final t in types) _discoverType(t, filters, maxPages),
    ]);

    // Mix movies and shows one by one so both stay near the top.
    final results = <SearchResult>[];
    final seen = <String>{};
    final longest = lists.fold<int>(0, (m, l) => l.length > m ? l.length : m);
    for (var i = 0; i < longest; i++) {
      for (final list in lists) {
        if (i >= list.length) continue;
        final r = list[i];
        if (seen.add('${r.type}-${r.id}')) results.add(r);
      }
    }
    return results;
  }

  final _genreIds = <String, Map<String, int>>{};

  /// Genre name -> id for one type ('movie' or 'tv'), cached.
  Future<Map<String, int>> _idsByName(String type) async {
    final cached = _genreIds[type];
    if (cached != null) return cached;
    final byId = await _api.getGenresFor(type);
    return _genreIds[type] = {
      for (final e in byId.entries) e.value: e.key,
    };
  }

  Future<List<SearchResult>> _discoverType(
    String type,
    SearchFilters f,
    int maxPages,
  ) async {
    final params = <String, dynamic>{
      'sort_by': 'popularity.desc',
      'include_adult': false,
    };

    if (f.genres.isNotEmpty) {
      final ids = await _idsByName(type);
      final wanted = [
        for (final name in f.genres)
          if (ids[name] != null) ids[name]!,
      ];
      // None of the chosen genres exist for this type (e.g. "Action" for TV).
      if (wanted.isEmpty) return [];
      // "|" means OR: any of the chosen genres.
      params['with_genres'] = wanted.join('|');
    }

    if (f.minRating > 0) {
      params['vote_average.gte'] = f.minRating;
      // Ignore titles with only a handful of votes.
      params['vote_count.gte'] = 50;
    }

    final decade = f.decade;
    if (decade != null) {
      final field = type == 'movie' ? 'primary_release_date' : 'first_air_date';
      if (decade == 1980) {
        params['$field.lte'] = '1989-12-31';
      } else {
        params['$field.gte'] = '$decade-01-01';
        params['$field.lte'] = '${decade + 9}-12-31';
      }
    }

    Future<Response> page(int p) => _api.dio.get(
          '/discover/$type',
          queryParameters: {...params, 'page': p},
        );

    final first = await page(1);
    final totalPages = (first.data['total_pages'] as int?) ?? 1;
    final rest = await Future.wait([
      for (var p = 2; p <= totalPages && p <= maxPages; p++) page(p),
    ]);

    return [
      for (final response in [first, ...rest])
        for (final raw in response.data['results'] as List)
          SearchResult.fromJson(raw, type),
    ];
  }

  /// Genre names for the filter sheet, straight from the API.
  Future<List<String>> genreNames(SearchType type) async {
    final types = switch (type) {
      SearchType.all => ['movie', 'tv'],
      SearchType.movies => ['movie'],
      SearchType.tv => ['tv'],
    };
    final names = <String>{};
    for (final t in types) {
      names.addAll((await _api.getGenresFor(t)).values);
    }
    return names.toList()..sort();
  }
}
