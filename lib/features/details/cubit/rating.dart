import 'package:flutter_bloc/flutter_bloc.dart';

class RatingCubit extends Cubit<int> {
  RatingCubit() : super(0);

  void selectRating(int rating) {
    if (rating >= 1 && rating <= 5) {
      emit(rating);
    }
  }
}
