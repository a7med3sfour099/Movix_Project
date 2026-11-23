import 'package:flutter_bloc/flutter_bloc.dart';

/// Keeps track of the current onboarding page (0 to 3).
class OnboardingCubit extends Cubit<int> {
  static const pageCount = 4;

  OnboardingCubit() : super(0);

  bool get isLast => state == pageCount - 1;

  void pageChanged(int index) => emit(index);
}