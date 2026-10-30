import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';

class CountsState {
  final bool loading;
  final String? error;
  final int movies;
  final int tvShows;
  final int actors;

  CountsState({
    this.loading = false,
    this.error,
    this.movies = 0,
    this.tvShows = 0,
    this.actors = 0,
  });
}

class CountsCubit extends Cubit<CountsState> {
  CountsCubit() : super(CountsState(loading: true));

  final api = MoviesApi();
  final sections = {
    '/discover/movie': 'movie',
    '/trending/all/day': 'movie',
    '/trending/all/week': 'movie',
    '/movie/top_rated': 'movie',
    '/tv/top_rated': 'tv',
    '/movie/popular': 'movie',
    '/tv/popular': 'tv',
    '/person/popular': 'person',
    '/movie/now_playing': 'movie',
  };

  Future<void> loadCounts() async {
    emit(CountsState(loading: true));
    try {
      final movies = <int>{};
      final tvShows = <int>{};
      final actors = <int>{};

      final results = await Future.wait([
        for (final section in sections.entries)
          api.getList(section.key, section.value, pages: 2),
        api.getUpcoming(),
      ]);

      for (final items in results) {
        for (final item in items) {
          if (item.type == 'movie') movies.add(item.id);
          if (item.type == 'tv') tvShows.add(item.id);
          if (item.type == 'person') actors.add(item.id);
        }
      }

      emit(CountsState(
        movies: movies.length,
        tvShows: tvShows.length,
        actors: actors.length,
      ));
    } catch (e) {
      emit(CountsState(error: 'Something went wrong, try again'));
    }
  }
}