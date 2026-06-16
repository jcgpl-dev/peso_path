import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peso_path/features/auth/domain/usecases/update_profile_pic.dart';
import '../../../../core/session/current_user.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/logout_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final UpdateProfilePic _updateProfilePic;
  final CurrentUser currentUser;

  AuthBloc({
    required this.registerUser,
    required this.loginUser,
    required this.logoutUser,
    required UpdateProfilePic updateProfilePic,
    required this.currentUser,
  }) : _updateProfilePic = updateProfilePic,
       super(AuthInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UploadProfilePictureRequested>(_onUploadProfilePicture);
  }

  Future<void> _onUploadProfilePicture(
    UploadProfilePictureRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      try {
        await _updateProfilePic(event.userId, event.imagePath);

        emit(
          AuthAuthenticated(
            userId: currentState.userId,
            name: currentState.name,
            username: currentState.username,
            profilePicture: event.imagePath,
          ),
        );
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await logoutUser();
      currentUser.setUser('');
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
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

      currentUser.setUser(user.id);

      emit(
        AuthAuthenticated(
          userId: user.id,
          name: user.name,
          username: user.username,
          profilePicture: user.profilePicture,
        ),
      );
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
