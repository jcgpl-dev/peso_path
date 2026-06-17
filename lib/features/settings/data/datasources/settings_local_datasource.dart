import 'package:peso_path/core/database/database_helper.dart';

abstract class SettingsLocalDataSource {
  Future<void> clearAllTables();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final DatabaseHelper _dbHelper;

  SettingsLocalDataSourceImpl(this._dbHelper);

  @override
  Future<void> clearAllTables() async {
    final db = await _dbHelper.database;

    await db.transaction((txn) async {
      await txn.delete('users');
      await txn.delete('transactions');
      await txn.delete('budget_cycles');
      await txn.delete('savings_goals');
    });
  }
}
