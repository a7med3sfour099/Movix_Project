import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/network/firebase_error_handler.dart';
import 'package:movixapp/core/services/auth_service.dart';

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

  final AuthService _authService = authService.value;

  Future<void> resetPassword() async {
    emit(ForgetPasswordLoading());
    try {
      await _authService.sendPasswordResetEmail(email: emailController.text);
      if (isClosed) return;
      emit(ForgetPasswordSuccess());
    } catch (error) {
      if (isClosed) return;
      emit(ForgetPasswordFailure(FirebaseErrorHandler.getMessage(error)));
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}
