import 'package:peso_path/features/settings/domain/entities/app_version_info.dart';

abstract class SettingsRepository {
  Future<void> clearAllUserData();
  Future<AppVersionInfo> getAppVersionInfo();
  Future<void> saveThemePreference(bool isDarkMode);
  Future<bool> loadThemePreference();
}
