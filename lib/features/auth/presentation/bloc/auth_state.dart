abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String username;

  AuthAuthenticated(this.username);
}

class AuthFailure extends AuthState {
  final String message;

  AuthFailure(this.message);
}
