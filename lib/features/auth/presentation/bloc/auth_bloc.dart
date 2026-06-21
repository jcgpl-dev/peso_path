import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peso_path/features/auth/domain/usecases/get_all_accounts.dart';
import 'package:peso_path/features/auth/domain/usecases/switch_account.dart';
import 'package:peso_path/features/auth/domain/usecases/update_profile_pic.dart';
import '../../../../core/session/current_user.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_user.dart';
import '../../domain/usecases/register_user.dart';
import '../../domain/usecases/logout_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../data/datasources/auth_local_datasource.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegisterUser registerUser;
  final LoginUser loginUser;
  final LogoutUser logoutUser;
  final UpdateProfilePic _updateProfilePic;
  final CurrentUser currentUser;
  final AuthLocalDataSource authLocalDataSource;
  final SwitchAccount switchAccount;
  final GetAllAccounts getAllAccounts;
  AuthBloc({
    required this.registerUser,
    required this.loginUser,
    required this.logoutUser,
    required UpdateProfilePic updateProfilePic,
    required this.currentUser,
    required this.authLocalDataSource,
    required this.switchAccount,
    required this.getAllAccounts,
  }) : _updateProfilePic = updateProfilePic,
       super(AuthInitial()) {
    on<RegisterRequested>(_onRegisterRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<UploadProfilePictureRequested>(_onUploadProfilePicture);
    on<RestoreSessionRequested>(_onRestoreSession);

    on<LoadAllAccountsRequested>(_onLoadAllAccounts);
    on<SwitchAccountRequested>(_onSwitchAccount);
  }

  Future<void> _onLoadAllAccounts(
    LoadAllAccountsRequested event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthAuthenticated) {
      final currentState = state as AuthAuthenticated;
      try {
        final List<User> accounts = await authLocalDataSource.getAllUsers();

        emit(
          AuthAuthenticated(
            userId: currentState.userId,
            name: currentState.name,
            username: currentState.username,
            profilePicture: currentState.profilePicture,
            availableAccounts: accounts,
          ),
        );
      } catch (e) {
        emit(AuthFailure('Failed to load accounts: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSwitchAccount(
    SwitchAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await authLocalDataSource.getUserById(event.userId);
      if (user == null) {
        emit(const AuthFailure('Selected account profile no longer exists.'));
        return;
      }

      await authLocalDataSource.saveUserSession(user.id);
      currentUser.setUser(user.id);

      final List<User> accounts = await authLocalDataSource.getAllUsers();

      emit(
        AuthAuthenticated(
          userId: user.id,
          name: user.name,
          username: user.username,
          profilePicture: user.profilePicture,
          availableAccounts: accounts,
        ),
      );
    } catch (e) {
      emit(AuthFailure('Error switching profiles: ${e.toString()}'));
    }
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
      await authLocalDataSource.clearUserSession();
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

      if (event.keepLoggedIn) {
        await authLocalDataSource.saveUserSession(user.id);
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

  Future<void> _onRestoreSession(
    RestoreSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userId = await authLocalDataSource.getStoredUserId();
      if (userId != null && userId.isNotEmpty) {
        final user = await authLocalDataSource.getUserById(userId);

        if (user != null) {
          currentUser.setUser(user.id);
          emit(
            AuthAuthenticated(
              userId: user.id,
              name: user.name,
              username: user.username,
              profilePicture: user.profilePicture,
            ),
          );
        } else {
          emit(AuthInitial());
        }
      } else {
        emit(AuthInitial());
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
