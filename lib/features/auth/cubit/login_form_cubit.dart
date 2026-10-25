import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginFormCubit extends Cubit<int> {
  LoginFormCubit() : super(0);

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  Future<void> close() {
    emailController.dispose();
    passController.dispose();
    return super.close();
  }
}