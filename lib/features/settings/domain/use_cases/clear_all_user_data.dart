import 'package:peso_path/features/settings/domain/repositories/settings_repository.dart';

class ClearAllUserData {
  final SettingsRepository repository;

  ClearAllUserData(this.repository);

  Future<void> call() async {
    return await repository.clearAllUserData();
  }
}
