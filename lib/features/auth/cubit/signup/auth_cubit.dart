import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  Future<void> signUp() async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(AuthSuccess());
  }
  Future<void> login({
  required String email,
  required String password,
}) async {
  emit(AuthLoading());

  try {
    // Temporary simulation until Firebase integration
    await Future.delayed(const Duration(seconds: 2));

    if (isClosed) return;

    emit(AuthSuccess());
  } catch (e) {
    if (isClosed) return;

    emit(AuthFailure(e.toString()));
  }
}
}

