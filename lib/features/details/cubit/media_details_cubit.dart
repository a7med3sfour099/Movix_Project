import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/details/data/details_api.dart';
import 'package:movixapp/features/details/data/media_details.dart';

class MediaDetailsState {
  final bool loading;
  final String? error;
  final MediaDetails? details;

  const MediaDetailsState({this.loading = false, this.error, this.details});
}

class MediaDetailsCubit extends Cubit<MediaDetailsState> {
  final String type;
  final int id;
  final _api = DetailsApi();

  MediaDetailsCubit({required this.type, required this.id})
      : super(const MediaDetailsState(loading: true));

  Future<void> load() async {
    emit(const MediaDetailsState(loading: true));
    try {
      final details = await _api.getDetails(type, id);
      if (isClosed) return;
      emit(MediaDetailsState(details: details));
    } catch (e) {
      if (isClosed) return;
      emit(const MediaDetailsState(error: 'Something went wrong, try again'));
    }
  }
}
