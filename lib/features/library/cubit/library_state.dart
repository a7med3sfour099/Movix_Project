import 'package:movixapp/features/home/data/media_item.dart';

class LibraryState {
  final List<MediaItem> favorites;
  final List<MediaItem> watchlist;

  /// Everything the user marked as watched (newest first).
  final List<MediaItem> history;

  const LibraryState({
    this.favorites = const [],
    this.watchlist = const [],
    this.history = const [],
  });

  LibraryState copyWith({
    List<MediaItem>? favorites,
    List<MediaItem>? watchlist,
    List<MediaItem>? history,
  }) {
    return LibraryState(
      favorites: favorites ?? this.favorites,
      watchlist: watchlist ?? this.watchlist,
      history: history ?? this.history,
    );
  }
}
