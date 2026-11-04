abstract class AuthState {}

class AuthInitial extends AuthState {}

enum AuthMethod {
  email,
  google,
  facebook,
  twitter,
}

class AuthLoading extends AuthState {
  final AuthMethod authMethod;
  AuthLoading(this.authMethod);
}

class AuthGuest extends AuthState {}

class AuthGuestLoading extends AuthState {}

class AuthPasswordChanged extends AuthState {
  final String password;
  final String confirmPassword;
  AuthPasswordChanged({required this.password, required this.confirmPassword});
}

class AuthSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}
