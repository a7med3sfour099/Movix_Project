import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/data/media_repository.dart';
import 'package:movixapp/core/network/result.dart';
import 'package:movixapp/features/home/cubit/media_grid_state.dart';
import 'package:movixapp/features/home/data/media_item.dart';

// typedef PageResult = ({List<MediaItem> items, bool hasMore});
typedef PageFetcher = Future<Result<PageResult>> Function(int page);

class MediaGridCubit extends Cubit<MediaGridState> {
  final PageFetcher fetch;
  int _page = 1;
  int _requestId = 0;
  bool _filling = false;

  // The search text and the sort are kept here, so they stay when the list
  // is reloaded (for example when a filter changes).
  String _query = '';
  GridSort _sort = GridSort.original;

  GridSort get sort => _sort;

  /// When searching or sorting, pages are loaded for the user up to this many.
  static const _maxFillPages = 10;

  MediaGridCubit(this.fetch) : super(MediaGridInitial());

  Future<void> load() async {
    final id = ++_requestId;
    _page = 1;
    emit(MediaGridLoading());
    final result = await fetch(1);
    if (id != _requestId || isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(MediaGridLoaded(
          items: data.items,
          hasMore: data.hasMore,
          query: _query,
          sort: _sort,
        ));
        _fillIfNeeded();
      case Failure(:final exception):
        emit(MediaGridFailure(exception.userMessage));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! MediaGridLoaded) return;
    if (current.loadingMore || !current.hasMore) return;

    final id = _requestId;
    emit(current.copyWith(loadingMore: true));
    final result = await fetch(_page + 1);
    if (id != _requestId || isClosed) return;

    // The search text or the sort may have changed while waiting.
    final latest = state is MediaGridLoaded ? state as MediaGridLoaded : current;
    switch (result) {
      case Success(:final data):
        _page++;
        emit(latest.copyWith(
          items: _merge(latest.items, data.items),
          hasMore: data.hasMore,
          loadingMore: false,
        ));
      case Failure():
        emit(latest.copyWith(loadingMore: false, hasMore: false));
    }
  }

  void setQuery(String text) {
    _query = text.trim();
    final current = state;
    if (current is MediaGridLoaded) emit(current.copyWith(query: _query));
    _fillIfNeeded();
  }

  void setSort(GridSort sort) {
    _sort = sort;
    final current = state;
    if (current is MediaGridLoaded) emit(current.copyWith(sort: sort));
    _fillIfNeeded();
  }

  /// A search or a sort only sees what is loaded, so while one is active
  /// the next pages are loaded automatically (up to [_maxFillPages]).
  Future<void> _fillIfNeeded() async {
    if (_filling) return;
    _filling = true;
    try {
      while (!isClosed && (_query.isNotEmpty || _sort != GridSort.original)) {
        final current = state;
        if (current is! MediaGridLoaded ||
            !current.hasMore ||
            _page >= _maxFillPages) {
          break;
        }
        if (current.loadingMore) {
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
