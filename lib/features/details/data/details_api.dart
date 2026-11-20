import 'package:dio/dio.dart';
import 'package:movixapp/core/api_config.dart';
import 'package:movixapp/features/details/data/media_details.dart';

class DetailsApi {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {'Authorization': 'Bearer ${ApiConfig.token}'},
    ),
  );

  /// One request gets everything the details screen needs.
  Future<MediaDetails> getDetails(String type, int id) async {
    final extra = type == 'tv'
        ? 'videos,aggregate_credits,content_ratings'
        : 'videos,credits,release_dates';
    final response = await dio.get(
      '/$type/$id',
      queryParameters: {
        'append_to_response': extra,
        // without this TMDB only returns videos in one language
        'include_video_language': 'en,null',
      },
    );
    return MediaDetails.fromJson(response.data, type);
  }
}
