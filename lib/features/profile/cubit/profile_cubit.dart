import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/profile_database.dart';

class ProfileCubit extends Cubit<String> {
  ProfileCubit() : super('') {
    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        emit('');
        return;
      }

      final path = await database.getImagePath();

      if (!isClosed &&
          FirebaseAuth.instance.currentUser?.uid == user.uid) {
        emit(path);
      }
    });
  }

  final ProfileDatabase database = ProfileDatabase();

  late final StreamSubscription<User?> _authSubscription;

  bool _isPickingImage = false;

  Future<void> loadImage() async {
    final path = await database.getImagePath();

    if (!isClosed) {
      emit(path);
    }
  }

  Future<void> changeImage() async {
    if (_isPickingImage) return;

    _isPickingImage = true;

    try {
      final path = await database.pickImage();

      if (path != '' && !isClosed) {
        emit(path);
      }
    } finally {
      _isPickingImage = false;
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
