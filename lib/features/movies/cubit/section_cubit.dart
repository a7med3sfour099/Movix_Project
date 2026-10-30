import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/movies/data/media_item.dart';

class SectionState {
  final bool loading;
  final String? error;
  final List<MediaItem> items;

  SectionState({this.loading = false, this.error, this.items = const []});
}

class SectionCubit extends Cubit<SectionState> {
  final Future<List<MediaItem>> Function() fetch;

  SectionCubit(this.fetch) : super(SectionState(loading: true));

  Future<void> loadItems() async {
    emit(SectionState(loading: true));
    try {
      final items = await fetch();
      emit(SectionState(items: items));
    } catch (e) {
      emit(SectionState(error: 'Something went wrong, try again'));
    }
  }
}
