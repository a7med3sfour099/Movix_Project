import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/auth/cubit/change_password/change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState>{
  ChangePasswordCubit() :super(ChangePasswordInitial());

  @override
  void onChange(Change<ChangePasswordState> change) {
    super.onChange(change);
    debugPrint('Cubit change: ${change.currentState} -> ${change.nextState}');
  }

  Future<void> changePassword ({required String currentPassword, required String newPassword}) async {
    emit(ChangePasswordLoading());

    try {
      // api call here
      await Future.delayed(const Duration(seconds: 2));
      emit(ChangePasswordSuccess());
    }
    catch(e){
      emit(ChangePasswordFailure(e.toString()));

    }
  }

}