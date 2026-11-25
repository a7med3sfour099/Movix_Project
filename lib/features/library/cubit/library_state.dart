import 'package:movixapp/features/home/data/media_item.dart';

class LibraryState {
  final List<MediaItem> favorites;
  final List<MediaItem> watchlist;

  const LibraryState({
    this.favorites = const [],
    this.watchlist = const [],
  });

  LibraryState copyWith({
    List<MediaItem>? favorites,
    List<MediaItem>? watchlist,
  }) {
    return LibraryState(
      favorites: favorites ?? this.favorites,
      watchlist: watchlist ?? this.watchlist,
    );
  }
}
