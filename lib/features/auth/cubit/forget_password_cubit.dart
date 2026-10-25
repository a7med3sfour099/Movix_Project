import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ForgetPasswordState {}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordSuccess extends ForgetPasswordState {}

class ForgetPasswordFailure extends ForgetPasswordState {
  final String message;

  ForgetPasswordFailure(this.message);
}

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  Future<void> resetPassword() async {
    emit(ForgetPasswordLoading());
    await Future.delayed(const Duration(seconds: 2));

    if (isClosed) return;

    emit(ForgetPasswordSuccess());
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}