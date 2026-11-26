import 'package:movixapp/features/home/data/movie_details.dart';

sealed class HeroState {
  const HeroState();
}
class HeroInitial extends HeroState {}
class HeroLoading extends HeroState {}
class HeroLoaded extends HeroState {
  final Movie movie;
  const HeroLoaded(this.movie);
}
class HeroFailure extends HeroState {
  final String message;
  const HeroFailure(this.message);
}