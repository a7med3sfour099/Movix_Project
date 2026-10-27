
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/services/auth_service.dart';

abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordFailure extends ResetPasswordState {
  final String message;

  ResetPasswordFailure(this.message);
}

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({required this.oobCode})
      : super(ResetPasswordInitial());

  final String oobCode;
  final AuthService _authService = authService.value;

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
          'Could not reset password. The link may have expired or already been used.',
        ),
      );
    }
  }
}
