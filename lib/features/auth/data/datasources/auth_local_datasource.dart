import '../../../../core/database/database_helper.dart';
import '../models/user_model.dart';

class AuthLocalDataSource {
  final dbHelper = DatabaseHelper.instance;

  Future<void> registerUser(UserModel user) async {
    final db = await dbHelper.database;

    await db.insert('users', user.toMap());
  }

  Future<UserModel?> loginUser(String username, String password) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return UserModel.fromMap(result.first);
  }

  Future<UserModel?> getUserById(String id) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return UserModel.fromMap(result.first);
  }

  Future<UserModel?> getUserByUsername(String username) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return UserModel.fromMap(result.first);
  }
}
