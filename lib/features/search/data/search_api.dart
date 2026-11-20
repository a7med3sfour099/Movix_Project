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
