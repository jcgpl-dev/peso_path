import 'package:equatable/equatable.dart';
import 'package:peso_path/features/auth/domain/entities/user.dart';

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
  final List<User> availableAccounts;

  const AuthAuthenticated({
    required this.userId,
    required this.name,
    required this.username,
    this.profilePicture,
    this.availableAccounts = const [],
  });

  @override
  List<Object?> get props => [
    userId,
    username,
    name,
    profilePicture,
    availableAccounts,
  ];
}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object?> get props => [message];
}
