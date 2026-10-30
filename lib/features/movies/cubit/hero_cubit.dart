import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/movies/data/movie_details.dart';
import 'package:movixapp/features/movies/data/movies_api.dart';
class HeroState {
  final bool loading;
  final String? error;
  final Movie? movie;

  HeroState({this.loading = false, this.error, this.movie});
}

class HeroCubit extends Cubit<HeroState> {
  HeroCubit() : super(HeroState(loading: true));

  final api = MoviesApi();

  Future<void> loadMovie() async {
    emit(HeroState(loading: true));
    try {
      final movie = await api.findMovie('The Odyssey', '2026');
      emit(HeroState(movie: movie));
    } catch (e) {
      emit(HeroState(error: 'Something went wrong, try again'));
    }
  }
}
