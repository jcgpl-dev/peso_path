import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthRegistered extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String name;
  final String username;
  final String? profilePicture;

  const AuthAuthenticated({
    required this.userId,
    required this.name,
    required this.username,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [userId, username, name];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
