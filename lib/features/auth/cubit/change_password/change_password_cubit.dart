import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/services/auth_service.dart';
import 'package:movixapp/features/auth/cubit/change_password/change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  @override
  void onChange(Change<ChangePasswordState> change) {
    super.onChange(change);
    debugPrint('Cubit change: ${change.currentState} -> ${change.nextState}');
  }

  final AuthService _authService = authService.value;

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    emit(ChangePasswordLoading());

    try {
      final user = _authService.currentUser;
      if (user == null || user.email == null) {
        emit(const ChangePasswordFailure("No user logged in."));
        return;
      }

      await _authService.changePassword(
        email: user.email!,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      if (isClosed) return;
      emit(ChangePasswordSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(ChangePasswordFailure(e.toString()));
    }
  }
}
