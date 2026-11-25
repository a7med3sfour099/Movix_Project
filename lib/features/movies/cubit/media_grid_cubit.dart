// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:movixapp/features/home/data/media_item.dart';

// typedef PageResult = ({List<MediaItem> items, bool hasMore});
// typedef PageFetcher = Future<PageResult> Function(int page);

// class MediaGridState {
//   final bool loading;
//   final bool loadingMore;
//   final bool hasMore;
//   final String? error;
//   final List<MediaItem> items;

//   const MediaGridState({
//     this.loading = false,
//     this.loadingMore = false,
//     this.hasMore = false,
//     this.error,
//     this.items = const [],
//   });
// }

// /// Loads a paginated list of media items (page 1, then more on scroll).
// /// Calling [load] again restarts from page 1 (used when filters change).
// class MediaGridCubit extends Cubit<MediaGridState> {
//   final PageFetcher fetch;
//   int _page = 1;
//   int _requestId = 0;

//   MediaGridCubit(this.fetch) : super(const MediaGridState(loading: true));

//   Future<void> load() async {
//     final id = ++_requestId;
//     _page = 1;
//     emit(const MediaGridState(loading: true));
//     try {
//       final result = await fetch(1);
//       if (id != _requestId || isClosed) return;
//       emit(
//         MediaGridState(
//           items: _merge(const [], result.items),
//           hasMore: result.hasMore,
//         ),
//       );
//     } catch (e) {
//       if (id != _requestId || isClosed) return;
//       emit(const MediaGridState(error: 'Something went wrong, try again'));
//     }
//   }

//   Future<void> loadMore() async {
//     final current = state;
//     if (current.loading || current.loadingMore || !current.hasMore) return;
//     final id = _requestId;
//     emit(
//       MediaGridState(items: current.items, hasMore: true, loadingMore: true),
//     );
//     try {
//       final result = await fetch(_page +1);
//       if (id != _requestId || isClosed) return;
//       _page++;
//       emit(
//         MediaGridState(
//           items: _merge(current.items, result.items),
//           hasMore: result.hasMore,
//         ),
//       );
//     } catch (e) {
//       if (id != _requestId || isClosed) return;
//       // Keep what we have and stop trying to load more.
//       emit(MediaGridState(items: current.items));
//     }
//   }

//   List<MediaItem> _merge(List<MediaItem> old, List<MediaItem> added) {
//     final seen = old.map((e) => e.id).toSet();
//     return [...old, ...added.where((e) => seen.add(e.id))];
//   }
// }
