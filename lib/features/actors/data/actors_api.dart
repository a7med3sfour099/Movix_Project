import 'package:dio/dio.dart';
import 'package:movixapp/core/network/dio_client.dart';
import 'package:movixapp/features/actors/data/actor.dart';
import 'package:movixapp/features/actors/data/person_details.dart';

typedef ActorsPage = ({List<Actor> items, bool hasMore, int nextPage});

class ActorsApi {
  static const popularPath = '/person/popular';
  static const trendingDayPath = '/trending/person/day';
  static const trendingWeekPath = '/trending/person/week';

  final Dio dio = DioClient.instance.dio;

  /*TMDB doesn't support gender filtering,so I filter actors here and keep loading more pages
  if needed to get enough results
  */
  Future<ActorsPage> getPage(
    String path, {
    int page = 1,
    ActorGender gender = ActorGender.all,
    int minItems = 12,
  } )  async {
    final items = <Actor>[];
    var current = page;
    var hasMore = true;
    var requests = 0;

    while (items.length < minItems && hasMore && requests < 5) {
      final response = await dio.get(
        path,
        queryParameters: {'page': current, 'include_adult': false},
      );
      for (final raw in response.data['results'] as List) {
        if (raw['profile_path'] == null) continue;
        final actor = Actor.fromJson(raw);
        if (actor.department != 'Acting') continue;
        if (!actor.matches(gender)) continue;
        items.add(actor);
      }
      final totalPages = (response.data['total_pages'] as int?) ?? 1;
      current++;
      requests++;
      hasMore = current <= totalPages && current <= 500;
    }
    return (items: items, hasMore: hasMore, nextPage: current);
  }

  Future<PersonDetails> getPerson(int id) async {
    final response = await dio.get(
      '/person/$id',
      queryParameters: {'append_to_response': 'images,combined_credits'},
    );
    return PersonDetails.fromJson(response.data);
  }
}
