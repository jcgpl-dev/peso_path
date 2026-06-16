import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:uuid/uuid.dart';
import 'package:peso_path/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:peso_path/features/auth/data/models/user_model.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Auth Feature', () {
    test('register and login user', () async {
      final datasource = AuthLocalDataSource();

      final uuid = Uuid();

      final user = UserModel(
        id: uuid.v4(),
        name: 'John Mark',
        username: 'markjohn',
        password: '123456',
        createdAt: DateTime.now().toIso8601String(),
      );

      await datasource.registerUser(user);

      final result = await datasource.loginUser('john', '123456');

      expect(result, isNotNull);
      expect(result!.username, 'john');
    });
  });
}
