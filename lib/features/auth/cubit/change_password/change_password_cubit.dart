import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/auth/cubit/change_password/change_password_state.dart';
import 'package:movixapp/core/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState>{
  ChangePasswordCubit() :super(ChangePasswordInitial());
  int passwordUiVersion = 0;

  @override
  void onChange(Change<ChangePasswordState> change) {
    super.onChange(change);
    debugPrint('Cubit change: ${change.currentState} -> ${change.nextState}');
  }

  // Future<void> changePassword ({required String currentPassword, required String newPassword}) async {
  //   emit(ChangePasswordLoading());

  //   try {
  //     //await Future.delayed(const Duration(seconds: 2));
  //     emit(ChangePasswordSuccess());
  //   }
  //   catch(e){
  //     emit(ChangePasswordFailure(e.toString()));

  //   }
  // }
  Future<void> changePassword({
  required String currentPassword,
  required String newPassword,
}) async {
  emit(ChangePasswordLoading());

  try {
    final user = authService.value.currentUser;

    if (user == null || user.email == null) {
      emit(
        const ChangePasswordFailure(
          "Please log in first",
        ),
      );
      return;
    }

    await authService.value.resetPassword(
      email: user.email!,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    emit(ChangePasswordSuccess()); }
  //  catch (e) {
  //   emit(ChangePasswordFailure(e.toString()));
  // }
  on FirebaseAuthException catch (e) {
  String message;

  switch (e.code) {
    case 'wrong-password':
    case 'invalid-credential':
      message = 'Current password is incorrect';
      break;

    case 'weak-password':
      message = 'New password is too weak';
      break;

    case 'requires-recent-login':
      message = 'Please log in again and try again';
      break;

    case 'network-request-failed':
      message = 'Please check your internet connection';
      break;

    default:
      message = e.message ?? 'Something went wrong';
  }

  emit(ChangePasswordFailure(message));
} catch (e) {
  emit(
    const ChangePasswordFailure('Something went wrong. Please try again'),
  );
}
}

// void updatePasswordRequirements() {
//   passwordUiVersion++;
//   emit(ChangePasswordInitial());
// }
int _typingVersion = 0;

void updatePasswordRequirements() {
  emit(ChangePasswordTyping(++_typingVersion));
}
}
