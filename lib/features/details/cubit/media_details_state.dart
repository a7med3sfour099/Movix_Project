import 'package:movixapp/features/details/data/media_details.dart';

class MediaDetailsState {
  final bool loading;
  final String? error;
  final MediaDetails? details;

  const MediaDetailsState({this.loading = false, this.error, this.details});
}
