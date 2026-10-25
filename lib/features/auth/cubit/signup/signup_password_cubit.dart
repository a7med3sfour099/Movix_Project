import 'package:flutter_bloc/flutter_bloc.dart';

class SignupPasswordCubit extends Cubit<int> {
  SignupPasswordCubit() : super(0);

  String password = '';
  String confirmPassword = '';

  void passwordChanged({
    required String password,
    required String confirmPassword,
  }) {
    this.password = password;
    this.confirmPassword = confirmPassword;

    emit(state + 1);
  }
}