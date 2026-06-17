import 'package:peso_path/core/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SettingsLocalDataSource {
  Future<void> clearAllTables();
  Future<void> cacheThemeMode(bool isDarkMode);
  Future<bool> getThemeMode();
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final DatabaseHelper _dbHelper;

  static const _themeKey = 'KEY_THEME_MODE';

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

  @override
  Future<void> cacheThemeMode(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  @override
  Future<bool> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }
}
