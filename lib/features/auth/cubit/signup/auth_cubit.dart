import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/services/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

    final AuthService _authService = authService.value;
  // Sign up
  Future<void> signUp({
    required String email,
    required String password,
    String? userName,
  }) async {
    emit(AuthLoading());

    try {
      await _authService.signUp(
        email: email,
        password: password,
      );

      if (userName != null && userName.trim().isNotEmpty) {
        await _authService.updateUserName(
          userName: userName.trim(),
        );
      }

      if (isClosed) return;
      emit(AuthSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(AuthFailure(e.toString()));
    }
  }

  // Login
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      await _authService.signIn(
        email: email,
        password: password,
      );

      if (isClosed) return;
      emit(AuthSuccess());
    } catch (e) {
      if (isClosed) return;
      emit(AuthFailure(e.toString()));
    }
  }

  // Logout
  Future<void> logout() async {
    emit(AuthLoading());

    try {
      await _authService.signOut();

      if (isClosed) return;
      emit(AuthInitial());
    } catch (e) {
      if (isClosed) return;
      emit(AuthFailure(e.toString()));
    }
  }
}

