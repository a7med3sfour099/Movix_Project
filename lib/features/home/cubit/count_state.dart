sealed class CountsState {
  const CountsState();
}
class CountsInitial extends CountsState {}
class CountsLoading extends CountsState {}
class CountsLoaded extends CountsState {
  final int movies;
  final int tvShows;
  final int actors;
  const CountsLoaded({
    required this.movies,
    required this.tvShows,
    required this.actors,
  });

  int get total => movies + tvShows + actors;
}
class CountsFailure extends CountsState {
  final String message;
  const CountsFailure(this.message);
}