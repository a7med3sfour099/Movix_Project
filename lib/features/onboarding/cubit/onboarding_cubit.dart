import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/onboarding/data/onboarding_data.dart';

class OnboardingState {
  final int currentPage;
  final OnboardingData? data;

  const OnboardingState({this.currentPage = 0, this.data});

  OnboardingState copyWith({int? currentPage, OnboardingData? data}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
    );
  }
}

class OnboardingCubit extends Cubit<OnboardingState> {
  static const pageCount = 4;

  final PageController pageController = PageController();

  // The onboarding data is fixed (images from assets), so it is ready at once.
  OnboardingCubit() : super(OnboardingState(data: OnboardingData.preset));

  bool get isLastPage => state.currentPage == pageCount - 1;

  void pageChanged(int index) {
    if (index != state.currentPage) {
      emit(state.copyWith(currentPage: index));
    }
  }

  void nextPage() {
    if (!isLastPage && pageController.hasClients) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Future<void> close() {
    pageController.dispose();
    return super.close();
  }
}