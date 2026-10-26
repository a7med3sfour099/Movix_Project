
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorHandler {
  static String getMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        // Sign up errors
        case 'email-already-in-use':
          return 'This email is already registered.';

        case 'invalid-email':
          return 'Please enter a valid email address.';

        case 'weak-password':
          return 'Your password is too weak.';

        case 'operation-not-allowed':
          return 'This authentication method is not enabled.';

        // Login errors
        case 'user-not-found':
          return 'No account found with this email.';

        case 'wrong-password':
          return 'Incorrect email or password.';

        case 'invalid-credential':
          return 'Incorrect email or password.';

        case 'user-disabled':
          return 'This account has been disabled.';

        // Network and security errors
        case 'network-request-failed':
          return 'Check your internet connection and try again.';

        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';

        case 'requires-recent-login':
          return 'Please log in again to perform this action.';

        case 'credential-already-in-use':
          return 'This credential is already linked to another account.';

        default:
          return 'Authentication failed. Please try again.';
      }
    }

    return 'Something went wrong. Please try again.';
  }
}
