import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';
import 'package:movixapp/features/search/data/search_api.dart';
import 'package:movixapp/features/search/data/search_filters.dart';
import 'package:movixapp/features/search/data/search_result.dart';

class SearchState {
  final String query;
  final SearchFilters filters;
  final SearchSort sort;
  final bool ascending;
  final bool loading;
  final String? error;
  final List<SearchResult> results;

  const SearchState({
    this.query = '',
    this.filters = const SearchFilters(),
    this.sort = SearchSort.popularity,
    this.ascending = false,
    this.loading = false,
    this.error,
    this.results = const [],
  });

  SearchState copyWith({
    String? query,
    SearchFilters? filters,
    SearchSort? sort,
    bool? ascending,
    bool? loading,
    String? error,
    bool clearError = false,
    List<SearchResult>? results,
  }) {
    return SearchState(
      query: query ?? this.query,
      filters: filters ?? this.filters,
      sort: sort ?? this.sort,
      ascending: ascending ?? this.ascending,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      results: results ?? this.results,
    );
  }

  /// No search text, but filters are on: the list comes from the filters only.
  bool get browsing => query.isEmpty && filters.activeCount > 0;

  /// Genres that really came back from the API.
  List<String> get genreOptions {
    final names = <String>{};
    for (final r in results) {
      for (final id in r.genreIds) {
        final name = MoviesApi.genres[id];
        if (name != null) names.add(name);
      }
    }
    return names.toList()..sort();
  }

  /// Highest rating from the API (one decimal).
  double get maxRating {
    var highest = 0.0;
    for (final r in results) {
      if (r.rating > highest) highest = r.rating;
    }
    return (highest * 10).floor() / 10;
  }

  /// Decades that have at least one result.
  List<int?> get decadeOptions {
    final found = <int>{
      for (final r in results)
        if (r.year != null) decadeOf(r.year!),
    };
    return searchDecades.where((d) => d == null || found.contains(d)).toList();
  }

  /// Results after the filters and the sort are applied.
  List<SearchResult> get visible {
    final filtered = results.where(filters.matches).toList();
    return switch (sort) {
      SearchSort.popularity =>
      ascending ? filtered.reversed.toList() : filtered,
      SearchSort.rating => _sortBy(
        filtered,
            (r) => r.rating > 0,
            (a, b) => a.rating.compareTo(b.rating),
      ),
      SearchSort.releaseDate => _sortBy(
        filtered,
            (r) => r.date.isNotEmpty,
            (a, b) => a.date.compareTo(b.date),
      ),
      SearchSort.title => _sortBy(
        filtered,
            (r) => true,
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      ),
    };
  }

  /// Items without a value (no rating, no date) always go to the end.
  List<SearchResult> _sortBy(
      List<SearchResult> items,
      bool Function(SearchResult) hasValue,
      int Function(SearchResult, SearchResult) compare,
      ) {
    final valid = items.where(hasValue).toList()..sort(compare);
    final rest = items.where((r) => !hasValue(r));
    return [...(ascending ? valid : valid.reversed), ...rest];
  }
}

class SearchCubit extends Cubit<SearchState> {
  final SearchApi _api;
  int _requestId = 0;

  SearchCubit([SearchApi? api])
      : _api = api ?? SearchApi(),
        super(const SearchState());

  Future<void> search(String text) async {
    final query = text.trim();
    if (query == state.query && !state.loading && state.error == null) return;
    await _load(query);
  }

  Future<void> retry() => _load(state.query);
  /// Shows the loading effect right away, while the debounce is still waiting.
  void showLoading(String text) {
    emit(state.copyWith(
      query: text.trim(),
      loading: true,
      clearError: true,
    ));
  }
  Future<void> _load(String query) async {
    final id = ++_requestId;
    if (query.isEmpty) {
      // Filters only (no text): show everything that matches them.
      if (state.filters.activeCount > 0) {
        await _discover(id);
        return;
      }
      emit(state.copyWith(
        query: '',
        results: const [],
        loading: false,
        clearError: true,
      ));
      return;
    }

    emit(state.copyWith(query: query, loading: true, clearError: true));
    try {
      final results = await _api.search(query, state.filters.type);
      if (id != _requestId || isClosed) return;
      final loaded = state.copyWith(results: results, loading: false);
      emit(loaded.copyWith(filters: _cleanFilters(loaded)));
    } catch (_) {
      if (id != _requestId || isClosed) return;
      emit(state.copyWith(
        loading: false,
        results: const [],
        error: 'Something went wrong, try again',
      ));
    }
  }

  Future<void> _discover(int id) async {
    emit(state.copyWith(
      query: '',
      results: const [],
      loading: true,
      clearError: true,
    ));
    try {
      final results = await _api.discover(state.filters);
      if (id != _requestId || isClosed) return;
      // Filters are NOT cleaned here: the results were made from them.
      emit(state.copyWith(results: results, loading: false));
    } catch (_) {
      if (id != _requestId || isClosed) return;
      emit(state.copyWith(
        loading: false,
        results: const [],
        error: 'Something went wrong, try again',
      ));
    }
  }

  /// Removes any filter that does not exist in the new results.
  SearchFilters _cleanFilters(SearchState s) {
    final f = s.filters;
    final genres = s.genreOptions;
    final decades = s.decadeOptions;
    final highest = s.maxRating;

    return f.copyWith(
      genres: f.genres.where((g) => genres.contains(g)).toSet(),
      minRating: f.minRating > highest ? highest : f.minRating,
      clearDecade: !decades.contains(f.decade),
    );
  }

  void applyFilters(SearchFilters filters) {
    final typeChanged = filters.type != state.filters.type;
    emit(state.copyWith(filters: filters));

    // Empty search box: Apply shows the matching titles right away.
    if (state.query.isEmpty) {
      _load('');
      return;
    }
    // Movies / TV Shows use a different endpoint, the rest is filtered locally.
    if (typeChanged) _load(state.query);
  }

  void applySort(SearchSort sort, bool ascending) {
    emit(state.copyWith(sort: sort, ascending: ascending));
  }
}