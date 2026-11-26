import 'package:movixapp/features/home/data/media_item.dart';

class LibraryState {
  final List<MediaItem> favorites;
  final List<MediaItem> watchlist;

  /// Everything the user marked as watched (newest first).
  final List<MediaItem> history;

  /// The Library tab that was selected last (0 favorites, 1 watchlist, 2 history).
  final int selectedTab;

  const LibraryState({
    this.favorites = const [],
    this.watchlist = const [],
    this.history = const [],
    this.selectedTab = 0,
  });

  LibraryState copyWith({
    List<MediaItem>? favorites,
    List<MediaItem>? watchlist,
    List<MediaItem>? history,
    int? selectedTab,
  }) {
    return LibraryState(
      favorites: favorites ?? this.favorites,
      watchlist: watchlist ?? this.watchlist,
      history: history ?? this.history,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
