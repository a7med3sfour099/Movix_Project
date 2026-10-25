import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  Future<void> signUp() async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(AuthSuccess());
  }
}
