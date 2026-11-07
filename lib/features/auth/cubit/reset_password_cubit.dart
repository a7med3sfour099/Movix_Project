
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/network/firebase_error_handler.dart';
import 'package:movixapp/core/services/auth_service.dart';
import 'package:movixapp/features/auth/cubit/forget_password_state.dart';


class ResetPasswordCubit extends Cubit<ForgetPasswordState> {
  ResetPasswordCubit({required this.oobCode})
      : super(ForgetPasswordInitial());

  final AuthService _authService = authService.value;
  final String oobCode;

  final formKey = GlobalKey<FormState>();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

    @override
  Future<void> close() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }

  void onPasswordChanged() {
    if (isClosed) return;
    emit(ResetPasswordTyping());
  }

  void clearControllers() {
    newPasswordController.clear();
    confirmPasswordController.clear();
    formKey.currentState?.reset();
  }

  Future<void> resetPassword({
    required String newPassword,
  }) async {
    emit(ResetPasswordLoading());

    try {
      await _authService.confirmPasswordReset(
        oobCode: oobCode,
        newPassword: newPassword,
      );

      if (isClosed) return;
      emit(ResetPasswordSuccess());
    } catch (error) {
      if (isClosed) return;
      emit(
        ResetPasswordFailure(
         FirebaseErrorHandler.getMessage(error),
        ),
      );
    }
  }
}
