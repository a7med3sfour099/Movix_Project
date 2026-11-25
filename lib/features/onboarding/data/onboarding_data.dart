import 'package:movixapp/features/details/data/cast_member.dart';
import 'package:movixapp/features/details/data/media_details.dart';
import 'package:movixapp/features/movies/data/media_item.dart';

/// The movies shown in the onboarding illustrations.
/// Everything is fixed and the images come from the app assets,
/// so the onboarding opens instantly and never waits for the API.
class OnboardingData {
  /// The main movie: poster, backdrop, story, rating, cast.
  final MediaDetails featured;

  /// More movies (posters for the side cards and lists).
  /// [0] The Hunger Games, [1] The Odyssey, [2] Hexed (calendar card).
  final List<MediaItem> trending;

  const OnboardingData({required this.featured, required this.trending});

  /// Genre names for the ids used below (no API needed to show them).
  static const genreNames = {878: 'Science Fiction', 12: 'Adventure'};

  static const _images = 'assets/images';

  static final OnboardingData preset = OnboardingData(
    featured: const MediaDetails(
      id: 0,
      type: 'movie',
      title: 'Avengers: Doomsday',
      overview:
          'Beloved heroes from three distinct universes are set on a deadly '
          'collision course and face an existential threat unlike anything '
          'they\'ve ever encountered.',
      date: '2026-12-18',
      year: '2026',
      runtime: '2h 45m',
      rating: 'NR',
      rawRating: 0,
      voteCount: 0,
      certification: 'NR',
      language: 'English',
      genres: ['Science Fiction'],
      poster: '$_images/onboarding_avengers_poster.jpg',
      backdrop: '$_images/onboarding_avengers_backdrop.jpg',
      trailerKey: null,
      cast: [
        CastMember(
          id: 0,
          name: 'Robert Downey Jr.',
          character: 'Victor von Doom / Doctor Doom',
          image: '$_images/onboarding_robert_downey.jpg',
        ),
      ],
      status: 'Post Production',
    ),
    trending: [
      MediaItem(
        id: 1,
        title: 'The Hunger Games: Sunrise on the Reaping',
        year: '2026',
        date: '2026-11-20',
        type: 'movie',
        rating: 'NR',
        genreId: 878,
        image: '$_images/onboarding_hunger_games.jpg',
      ),
      MediaItem(
        id: 2,
        title: 'The Odyssey',
        year: '2026',
        date: '2026-07-17',
        type: 'movie',
        rating: 'NR',
        genreId: 12,
        image: '$_images/onboarding_odyssey.jpg',
      ),
      // Only used for the title and date on the calendar card (no poster).
      MediaItem(
        id: 3,
        title: 'Hexed',
        year: '2026',
        date: '2026-11-25',
        type: 'movie',
        rating: 'NR',
      ),
    ],
  );
}
