import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/constants/api_endpoints.dart';
import 'package:movixapp/core/data/media_repository.dart';
import 'package:movixapp/core/network/result.dart';
import 'package:movixapp/features/home/cubit/count_state.dart';

class CountsCubit extends Cubit<CountsState> {
  CountsCubit() : super(CountsInitial());

  // Only count titles people actually rated, so the numbers are real and
  // different per category (not just TMDB's huge raw totals).
  // Raise / lower these to change the numbers shown on the cards.
  static const _movieFilter = {'vote_count.gte': 300};
  static const _tvFilter = {'vote_count.gte': 100};

  Future<void> loadCounts() async {
    emit(CountsLoading());
    final repo = MediaRepository.instance;

    final results = await Future.wait([
      repo.getCount(ApiEndpoints.discoverMovies, query: _movieFilter),
      repo.getCount(ApiEndpoints.discoverTvShows, query: _tvFilter),
      repo.getCount(ApiEndpoints.popularActors),
    ]);

    if (isClosed) return;

    for (final r in results) {
      if (r case Failure(:final exception)) {
        emit(CountsFailure(exception.userMessage));
        return;
      }
    }

    emit(CountsLoaded(
      movies: (results[0] as Success<int>).data,
      tvShows: (results[1] as Success<int>).data,
      actors: (results[2] as Success<int>).data,
    ));
  }
}