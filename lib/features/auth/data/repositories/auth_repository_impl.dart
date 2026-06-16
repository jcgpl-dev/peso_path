import 'package:peso_path/core/database/database_helper.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.localDataSource);

  @override
  Future<void> register(User user) async {
    await localDataSource.registerUser(
      UserModel(
        id: user.id,
        name: user.name,
        username: user.username,
        password: user.password,
        createdAt: user.createdAt,
      ),
    );
  }

  @override
  Future<User?> login(String username, String password) async {
    return localDataSource.loginUser(username, password);
  }

  @override
  Future<void> logoutUser() async {
    try {
      //todo something...
    } catch (e) {
      throw Exception('Failed to sign out cleanly: $e');
    }
  }

  @override
  Future<void> updateProfilePicture(String userId, String imagePath) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'users',
      {'profile_picture': imagePath},
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
