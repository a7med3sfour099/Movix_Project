import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/network/firebase_error_handler.dart';
import 'package:movixapp/core/services/auth_service.dart';
import 'package:movixapp/features/auth/cubit/change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  final AuthService _authService = authService.value;

  final formKey = GlobalKey<FormState>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Future<void> close() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }

  void clearControllers() {
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
    formKey.currentState?.reset();
  }


  void onPasswordChanged() {
    if (isClosed) return;
    emit(ChangePasswordTyping());
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());

    try {
      final user = _authService.currentUser;
      if (user == null || user.email == null) {
        emit(
          ChangePasswordFailure(
            'No user is currently logged in. Please log in and try again.',
          ),
        );
        return;
      }

      await _authService.changePassword(
        email: user.email!,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (isClosed) return;
      clearControllers();
      emit(ChangePasswordSuccess());
    } catch (error) {
      if (isClosed) return;
      emit(
        ChangePasswordFailure(FirebaseErrorHandler.getMessage(error)),
      );
    }
  }
}
