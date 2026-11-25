import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/data/media_repository.dart';
import 'package:movixapp/core/network/result.dart';
import 'package:movixapp/features/home/cubit/hero_state.dart';

class HeroCubit extends Cubit<HeroState> {
  HeroCubit() : super(HeroInitial());

  Future<void> loadMovie() async {
    emit(HeroLoading());
    final result =
        await MediaRepository.instance.findMovie('The Odyssey', '2026');
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(HeroLoaded(data));
      case Failure(:final exception):
        emit(HeroFailure(exception.userMessage));
    }
  }
}