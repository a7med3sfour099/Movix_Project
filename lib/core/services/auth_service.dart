import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

ValueNotifier<AuthService> authService = ValueNotifier(AuthService());

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  /// Sign in with email and password
  Future<void> signIn({required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Sign up
  Future<void> signUp({required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Reset password
  Future<void> resetPassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.updatePassword(newPassword);
     } 
    //catch (e) {
    //   throw Exception(e);
    // }
    on FirebaseAuthException {
  rethrow;
}
  }

  /// Delete account
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await currentUser!.reauthenticateWithCredential(credential);
      await currentUser!.delete();
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Update user name
  Future<void> updateUserName({required String userName}) async {
    try {
      await firebaseAuth.currentUser?.updateDisplayName(userName);
    } catch (e) {
      throw Exception(e);
    }
  }

  /// Update photo url
  Future<void> updatePhotoUrl({required String photoUrl}) async {
    try {
      await firebaseAuth.currentUser?.updatePhotoURL(photoUrl);
    } catch (e) {
      throw Exception(e);
    }
  }
}