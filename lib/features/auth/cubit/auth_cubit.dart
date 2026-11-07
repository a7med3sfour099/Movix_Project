import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/core/network/firebase_error_handler.dart';
import 'package:movixapp/core/services/auth_service.dart';
import 'package:flutter/foundation.dart';

import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthService _authService = authService.value;

  final signupFormKey = GlobalKey<FormState>();
  final loginFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final loginEmailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Future<void> close() {
    nameController.dispose();
    signupEmailController.dispose();
    loginEmailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    return super.close();
  }

  // Clear all controllers
  void clearControllers ({bool clearLoginEmail = true}) {
    nameController.clear();
    signupEmailController.clear();
    if (clearLoginEmail) {
      loginEmailController.clear();
    }
    passwordController.clear();
    confirmPasswordController.clear();
  }

  // Update password fields
  void updatePasswordFields({
    required String password,
    required String confirmPassword,
  }) {
    emit(
      AuthPasswordChanged(password: password, confirmPassword: confirmPassword),
    );
  }

  // Sign up
  Future<void> signUp({
    required String email,
    required String password,
    String? userName,
  }) async {
    emit(AuthLoading(AuthMethod.email));

    try {
      await _authService.signUp(email: email.trim(), password: password);

      await _authService.sendEmailVerification();

      if (userName != null && userName.trim().isNotEmpty) {
        await _authService.updateUserName(userName: userName.trim());
      }

      await _authService.signOut();

      if (isClosed) return;
      emit(AuthSignupSuccess());
    } catch (error) {
      if (isClosed) return;
      emit(AuthFailure(FirebaseErrorHandler.getMessage(error)));
    }
  }

  // Login
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading(AuthMethod.email));

    try {
      await _authService.signIn(email: email, password: password);

      if (_authService.currentUser?.emailVerified != true) {
        await _authService.signOut();

        if (isClosed) return;

        emit(AuthFailure('Please verify your email before logging in.'));
        return;
      }

      if (isClosed) return;
      emit(AuthLoginSuccess());
    } catch (error) {
      if (isClosed) return;
      emit(AuthFailure(FirebaseErrorHandler.getMessage(error)));
    }
  }

  // Google Login
  Future<void> loginWithGoogle() async {
    emit(AuthLoading(AuthMethod.google));

    try {
      await _authService.signInWithGoogle();

      if (isClosed) return;
      emit(AuthSocialLoginSuccess());
    } catch (error, stackTrace) {
      debugPrint('GOOGLE LOGIN ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (isClosed) return;
      emit(AuthFailure(FirebaseErrorHandler.getMessage(error)));
    }
  }

  // Logout
  Future<void> logout() async {
    emit(AuthLoading(AuthMethod.email));

    try {
      await _authService.signOut();

      if (isClosed) return;
      emit(AuthInitial());
    } catch (error) {
      if (isClosed) return;
      emit(AuthFailure(FirebaseErrorHandler.getMessage(error)));
    }
  }

  // Facebook Login
  Future<void> loginWithFacebook() async {
    emit(AuthLoading(AuthMethod.facebook));

    try {
      await _authService.signInWithFacebook();

      if (isClosed) return;
      emit(AuthSocialLoginSuccess());
    } catch (error, stackTrace) {
      debugPrint('FACEBOOK LOGIN ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (isClosed) return;
      emit(AuthFailure(FirebaseErrorHandler.getMessage(error)));
    }
  }

  // Twitter / X Login
  Future<void> loginWithTwitter() async {
    emit(AuthLoading(AuthMethod.twitter));

    try {
      await _authService.signInWithTwitter();

      if (isClosed) return;
      emit(AuthSocialLoginSuccess());
    } catch (error, stackTrace) {
      debugPrint('TWITTER LOGIN ERROR: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (isClosed) return;
      emit(AuthFailure(FirebaseErrorHandler.getMessage(error)));
    }
  }

  // Guest Login
  Future<void> enterGuestMode() async {
    emit(AuthGuestLoading());

    await Future.delayed(const Duration(milliseconds: 1500));

    if (isClosed) return;

    emit(AuthGuest());
  }
}
