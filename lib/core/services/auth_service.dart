import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  /// Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign up
  Future<void> signUp({required String email, required String password}) async {
    await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  /// Reset password
  Future<void> resetPassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.updatePassword(newPassword);
  }

  /// Delete account
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await currentUser!.reauthenticateWithCredential(credential);
    await currentUser!.delete();
    await firebaseAuth.signOut();
  }

  /// Update user name
  Future<void> updateUserName({required String userName}) async {
    await firebaseAuth.currentUser?.updateDisplayName(userName);
  }

  /// Update photo url
  Future<void> updatePhotoUrl({required String photoUrl}) async {
    await firebaseAuth.currentUser?.updatePhotoURL(photoUrl);
  }
}
