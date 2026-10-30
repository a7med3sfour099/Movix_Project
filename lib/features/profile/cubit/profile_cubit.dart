import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/profile_database.dart';

class ProfileCubit extends Cubit<String> {
  ProfileCubit() : super('');

  ProfileDatabase database = ProfileDatabase();

  void loadImage() async {
    String path = await database.getImagePath();
    emit(path);
  }

  // new img
  void changeImage() async {
    String path = await database.pickImage();
    if (path != '') {
      emit(path);
    }
  }
}
