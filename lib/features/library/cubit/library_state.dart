import 'package:movixapp/features/home/data/media_item.dart';

class LibraryState {
  final List<MediaItem> favorites;
  final List<MediaItem> watchlist;
  final int selectedTab;

  const LibraryState({
    this.favorites = const [],
    this.watchlist = const [],
    this.selectedTab = 0,
  });

  LibraryState copyWith({
    List<MediaItem>? favorites,
    List<MediaItem>? watchlist,
    int? selectedTab,
  }) {
    return LibraryState(
      favorites: favorites ?? this.favorites,
      watchlist: watchlist ?? this.watchlist,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}
