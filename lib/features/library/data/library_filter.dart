import 'package:movixapp/features/home/data/media_item.dart';

/// The three pages inside Library.
enum LibraryTab { favorites, watchlist, history }

/// Movies / TV filter used inside every Library tab.
enum MediaFilter {
  all('All'),
  movies('Movies'),
  tv('TV Shows');

  const MediaFilter(this.label);
  final String label;

  bool matches(MediaItem item) => switch (this) {
        MediaFilter.all => true,
        MediaFilter.movies => item.type != 'tv',
        MediaFilter.tv => item.type == 'tv',
      };
}
