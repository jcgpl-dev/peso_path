import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  const LoginRequested({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class RegisterRequested extends AuthEvent {
  final String name;
  final String username;
  final String password;

  const RegisterRequested({
    required this.name,
    required this.username,
    required this.password,
  });

  @override
  List<Object?> get props => [name, username, password];
}

class LogoutRequested extends AuthEvent {}

class UploadProfilePictureRequested extends AuthEvent {
  final String userId;
  final String imagePath;

  const UploadProfilePictureRequested({
    required this.userId,
    required this.imagePath,
  });
}
