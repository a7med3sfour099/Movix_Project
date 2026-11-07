import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/network/firebase_error_handler.dart';
import 'package:movixapp/core/services/auth_service.dart';
import 'package:movixapp/features/auth/cubit/forget_password_state.dart';


class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  final AuthService _authService = authService.value;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }

void clearControllers() {
    emailController.clear();
    formKey.currentState?.reset();
  }

  Future<void> forgetPassword() async {
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

}
