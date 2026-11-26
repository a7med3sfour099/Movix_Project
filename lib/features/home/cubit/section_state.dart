import 'package:movixapp/features/home/data/media_item.dart';

sealed class SectionState {
  const SectionState();
}
class SectionInitial extends SectionState { const SectionInitial(); }
class SectionLoading extends SectionState { const SectionLoading(); }
class SectionLoaded extends SectionState {
  final List<MediaItem> items;
  const SectionLoaded(this.items);
}
class SectionFailure extends SectionState {
  final String message;
  const SectionFailure(this.message);
}