import 'package:flutter_bloc/flutter_bloc.dart';

class RatingCubit extends Cubit<int> {
  RatingCubit([int initialRating = 0]) : super(initialRating);

  void selectRating(int rating) {
    if (rating >= 1 && rating <= 5) {
      emit(rating);
    }
  }
}