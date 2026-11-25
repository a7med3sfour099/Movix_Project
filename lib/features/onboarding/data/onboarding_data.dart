import 'package:movixapp/features/details/data/details_api.dart';
import 'package:movixapp/features/details/data/media_details.dart';
import 'package:movixapp/features/home/data/media_item.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';

/// The real movies shown in the onboarding illustrations.
class OnboardingData {
  /// The main movie: poster, backdrop, story, rating, cast.
  final MediaDetails featured;

  /// A few more trending movies (posters for the side cards and lists).
  final List<MediaItem> trending;

  const OnboardingData({required this.featured, required this.trending});

  /// Returns null if anything fails, so the screen can show the plain
  /// placeholders instead of crashing.
  static Future<OnboardingData?> load() async {
    try {
      final list = await MoviesApi().getList(
        '/trending/movie/week',
        'movie',
        pages: 1,
      );
      final withPoster = list.where((m) => m.image != null).toList();
      if (withPoster.length < 3) return null;

      final featured = await DetailsApi().getDetails(
        'movie',
        withPoster.first.id,
      );
      return OnboardingData(
        featured: featured,
        trending: withPoster.skip(1).take(4).toList(),
      );
    } catch (_) {
      return null;
    }
  }
}