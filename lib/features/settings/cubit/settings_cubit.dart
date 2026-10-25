import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<bool> {
  SettingsCubit() : super(true);

  void toggleNotifications(bool value) {
    emit(value);
  }
}