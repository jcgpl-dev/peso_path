import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;
  final LoginUser loginUser;

  AuthBloc({required this.registerUser, required this.loginUser})
    : super(AuthInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = User(
        id: const Uuid().v4(),
        name: event.name,
        username: event.username,
        password: event.password,
        createdAt: DateTime.now().toIso8601String(),
      );

      await registerUser(user);

      emit(AuthRegistered());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final user = await loginUser(event.username, event.password);

      if (user == null) {
        emit(const AuthFailure('Invalid username or password'));
        return;
      }

      emit(AuthAuthenticated(user.username));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
