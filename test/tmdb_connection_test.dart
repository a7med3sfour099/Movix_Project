
import 'package:flutter_test/flutter_test.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';

void main() {
  test('TMDB API connection test', () async {
    final api = MoviesApi();

    final movies = await api.getTrending('day');

    expect(MoviesApi.genres, isNotEmpty);
    expect(movies, isA<List>());

    print('TMDB connection successful!');
    print('Loaded genres: ${MoviesApi.genres.length}');
    print('Loaded trending items: ${movies.length}');
  });
}
