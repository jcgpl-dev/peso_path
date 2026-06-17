import 'package:peso_path/features/settings/domain/repositories/settings_repository.dart';

class SaveThemePreference {
  final SettingsRepository repository;
  SaveThemePreference(this.repository);

  Future<void> call(bool isDarkMode) async =>
      await repository.saveThemePreference(isDarkMode);
}

class LoadThemePreference {
  final SettingsRepository repository;
  LoadThemePreference(this.repository);

  Future<bool> call() async => await repository.loadThemePreference();
}
