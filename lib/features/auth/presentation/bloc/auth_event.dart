abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested({required this.username, required this.password});
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String username;
  final String password;

  RegisterRequested({
    required this.name,
    required this.username,
    required this.password,
  });
}
