import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/movies/data/media_item.dart';

typedef PageResult = ({List<MediaItem> items, bool hasMore});
typedef PageFetcher = Future<PageResult> Function(int page);

/// How the loaded items are ordered. [original] = the order from the API.
enum GridSort { original, topRated, newest, title }

extension GridSortText on GridSort {
  String get label => switch (this) {
    GridSort.original => 'Default',
    GridSort.topRated => 'Top rated',
    GridSort.newest => 'Newest',
    GridSort.title => 'A \u2192 Z',
  };
}

class MediaGridState {
  final bool loading;
  final bool loadingMore;
  final bool hasMore;
  final String? error;
  final List<MediaItem> items;

  /// Search text (filters the loaded items by title).
  final String query;
  final GridSort sort;

  const MediaGridState({
    this.loading = false,
    this.loadingMore = false,
    this.hasMore = false,
    this.error,
    this.items = const [],
    this.query = '',
    this.sort = GridSort.original,
  });

  MediaGridState copyWith({
    bool? loading,
    bool? loadingMore,
    bool? hasMore,
    List<MediaItem>? items,
    String? query,
    GridSort? sort,
  }) {
    return MediaGridState(
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      items: items ?? this.items,
      query: query ?? this.query,
      sort: sort ?? this.sort,
    );
  }

  /// The items after the search text and the sort are applied.
  List<MediaItem> get visible {
    final text = query.trim().toLowerCase();
    var list = text.isEmpty
        ? items
        : items.where((i) => i.title.toLowerCase().contains(text)).toList();

    switch (sort) {
      case GridSort.original:
        return list;
      case GridSort.topRated:
        // "NR" (not rated) goes to the end.
        double rate(MediaItem i) => double.tryParse(i.rating) ?? -1;
        return [...list]..sort((a, b) => rate(b).compareTo(rate(a)));
      case GridSort.newest:
        // Items without a date go to the end.
        final dated = list.where((i) => i.date.isNotEmpty).toList()
          ..sort((a, b) => b.date.compareTo(a.date));
        return [...dated, ...list.where((i) => i.date.isEmpty)];
      case GridSort.title:
        return [...list]..sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
    }
  }
}

/// Loads a paginated list of media items (page 1, then more on scroll).
/// Calling [load] again restarts from page 1 (used when filters change).
class MediaGridCubit extends Cubit<MediaGridState> {
  final PageFetcher fetch;
  int _page = 1;
  int _requestId = 0;
  bool _filling = false;

  /// When searching or sorting, pages are loaded for the user up to this many.
  static const _maxFillPages = 10;

  MediaGridCubit(this.fetch) : super(const MediaGridState(loading: true));

  Future<void> load() async {
    final id = ++_requestId;
    _page = 1;
    emit(MediaGridState(
      loading: true,
      query: state.query,
      sort: state.sort,
    ));
    try {
      final result = await fetch(1);
      if (id != _requestId || isClosed) return;
      emit(MediaGridState(
        items: _merge(const [], result.items),
        hasMore: result.hasMore,
        query: state.query,
        sort: state.sort,
      ));
      _fillIfNeeded();
    } catch (e) {
      if (id != _requestId || isClosed) return;
      emit(MediaGridState(
        error: 'Something went wrong, try again',
        query: state.query,
        sort: state.sort,
      ));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current.loading || current.loadingMore || !current.hasMore) return;
    final id = _requestId;
    emit(current.copyWith(loadingMore: true));
    try {
      final result = await fetch(_page + 1);
      if (id != _requestId || isClosed) return;
      _page++;
      emit(state.copyWith(
        items: _merge(state.items, result.items),
        hasMore: result.hasMore,
        loadingMore: false,
      ));
    } catch (e) {
      if (id != _requestId || isClosed) return;
      // Keep what we have and stop trying to load more.
      emit(state.copyWith(loadingMore: false, hasMore: false));
    }
  }

  void setQuery(String text) {
    emit(state.copyWith(query: text.trim()));
    _fillIfNeeded();
  }

  void setSort(GridSort sort) {
    emit(state.copyWith(sort: sort));
    _fillIfNeeded();
  }

  /// A search or a sort only sees what is loaded, so while one is active
  /// the next pages are loaded automatically (up to [_maxFillPages]).
  Future<void> _fillIfNeeded() async {
    if (_filling) return;
    _filling = true;
    try {
      while (!isClosed &&
          (state.query.isNotEmpty || state.sort != GridSort.original) &&
          !state.loading &&
          state.error == null &&
          state.hasMore &&
          _page < _maxFillPages) {
        if (state.loadingMore) {
          // The scroll is already loading a page, wait for it.
          await Future.delayed(const Duration(milliseconds: 150));
          continue;
        }
        await loadMore();
      }
    } finally {
      _filling = false;
    }
  }

  List<MediaItem> _merge(List<MediaItem> old, List<MediaItem> added) {
    final seen = old.map((e) => e.id).toSet();
    return [...old, ...added.where((e) => seen.add(e.id))];
  }
}
