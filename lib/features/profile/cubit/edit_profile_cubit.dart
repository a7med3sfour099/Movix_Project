import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movixapp/features/profile/data/profile_database.dart';
import 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit() : super(const EditProfileState()) {
    _loadInitialImage();
  }

  final ProfileDatabase _database = ProfileDatabase();

  Future<void> _loadInitialImage() async {
    final path = await _database.getImagePath();
    if (!isClosed) {
      emit(state.copyWith(imagePath: path));
    }
  }

  Future<void> changeImage() async {
    final path = await _database.pickImage();
    if (path.isNotEmpty && !isClosed) {
      emit(state.copyWith(imagePath: path));
    }
  }

  Future<void> saveProfile(
    String newName, {
    required void Function() onSuccess,
    required void Function(String error) onError,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && newName.trim().isNotEmpty) {
        await user.updateDisplayName(newName.trim());
        await user.reload();
      }
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
        onSuccess();
      }
    } catch (e) {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false, error: e.toString()));
        onError(e.toString());
      }
    }
  }
}
