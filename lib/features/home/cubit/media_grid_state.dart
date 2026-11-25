import 'package:movixapp/features/home/data/media_item.dart';

sealed class MediaGridState {
  const MediaGridState();
}
class MediaGridInitial extends MediaGridState {}
class MediaGridLoading extends MediaGridState {}

class MediaGridLoaded extends MediaGridState {
  final List<MediaItem> items;
  final bool hasMore;
  final bool loadingMore;

  const MediaGridLoaded({
    required this.items,
    required this.hasMore,
    this.loadingMore = false,
  });

  MediaGridLoaded copyWith({
    List<MediaItem>? items,
    bool? hasMore,
    bool? loadingMore,
  }) =>
      MediaGridLoaded(
        items: items ?? this.items,
        hasMore: hasMore ?? this.hasMore,
        loadingMore: loadingMore ?? this.loadingMore,
      );
}

class MediaGridFailure extends MediaGridState {
  final String message;
  const MediaGridFailure(this.message);
}
