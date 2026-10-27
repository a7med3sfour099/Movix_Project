import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

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

  /// Change password
  Future<void> changePassword({
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

  /// Send password reset email

  Future<void> sendPasswordResetEmail({required String email}) async {
    final actionCodeSettings = ActionCodeSettings(
      url: 'https://movix-project-301f5.firebaseapp.com/finishReset',
      handleCodeInApp: true,
      androidPackageName: 'com.example.movixapp',
      iOSBundleId: 'com.example.movixapp',
    );

    await firebaseAuth.sendPasswordResetEmail(
      email: email.trim(),
      actionCodeSettings: actionCodeSettings,
    );
  }

  /// Confirm password reset
  Future<void> confirmPasswordReset({
    required String oobCode,
    required String newPassword,
  }) async {
    await firebaseAuth.confirmPasswordReset(
      code: oobCode,
      newPassword: newPassword,
    );
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

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    await googleSignIn.initialize(
      serverClientId: '851109101482-fc79db6qjoiv2knkp8itmva2dde2j2tr.apps.googleusercontent.com',
    );

    final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return await firebaseAuth.signInWithCredential(credential);
  }

  /// Sign in with Facebook
  Future<UserCredential> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login(
      permissions: ['public_profile'],
    );

    if (result.status == LoginStatus.success) {
      final AccessToken? accessToken = result.accessToken;

      if (accessToken == null) {
        throw Exception('Facebook access token is missing');
      }

      final OAuthCredential credential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );

      return await firebaseAuth.signInWithCredential(credential);
    }

    if (result.status == LoginStatus.cancelled) {
      throw Exception('Facebook login cancelled');
    }

    throw Exception(result.message ?? 'Facebook login failed');
  }

  /// Sign in with Twitter / X
  Future<UserCredential> signInWithTwitter() async {
    final twitterProvider = TwitterAuthProvider();

    return await firebaseAuth.signInWithProvider(twitterProvider);
  }
}
