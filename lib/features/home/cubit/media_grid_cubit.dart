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

  MediaGridCubit(this.fetch) : super(MediaGridInitial());

  Future<void> load() async {
    final id = ++_requestId;
    _page = 1;
    emit(MediaGridLoading());
    final result = await fetch(1);
    if (id != _requestId || isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(MediaGridLoaded(items: data.items, hasMore: data.hasMore));
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

    switch (result) {
      case Success(:final data):
        _page++;
        emit(MediaGridLoaded(
          items: _merge(current.items, data.items),
          hasMore: data.hasMore,
        ));
      case Failure():
        emit(current.copyWith(loadingMore: false));
    }
  }

  List<MediaItem> _merge(List<MediaItem> old, List<MediaItem> added) {
    final seen = old.map((e) => e.id).toSet();
    return [...old, ...added.where((e) => seen.add(e.id))];
  }
}