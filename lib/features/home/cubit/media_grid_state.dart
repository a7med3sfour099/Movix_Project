import 'package:movixapp/features/home/data/media_item.dart';

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

sealed class MediaGridState {
  const MediaGridState();
}
class MediaGridInitial extends MediaGridState {}
class MediaGridLoading extends MediaGridState {}

class MediaGridLoaded extends MediaGridState {
  final List<MediaItem> items;
  final bool hasMore;
  final bool loadingMore;

  /// Search text (filters the loaded items by title).
  final String query;
  final GridSort sort;
  /// True while the user is typing and the search has not started yet.
  final bool searching;

  const MediaGridLoaded({
    required this.items,
    required this.hasMore,
    this.loadingMore = false,
    this.query = '',
    this.sort = GridSort.original,
    this.searching = false,
  });

  MediaGridLoaded copyWith({
    List<MediaItem>? items,
    bool? hasMore,
    bool? loadingMore,
    String? query,
    GridSort? sort,
    bool? searching,
  }) =>
      MediaGridLoaded(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
        query: query ?? this.query,
        sort: sort ?? this.sort,
        searching: searching ?? this.searching,
      );

  /// The items after the search text and the sort are applied.
  List<MediaItem> get visible {
    final text = query.trim().toLowerCase();
    final list = text.isEmpty
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

class MediaGridFailure extends MediaGridState {
  final String message;
  const MediaGridFailure(this.message);
}
