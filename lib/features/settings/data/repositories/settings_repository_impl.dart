import 'package:peso_path/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:peso_path/features/settings/domain/entities/app_version_info.dart';
import 'package:peso_path/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<void> clearAllUserData() async {
    await localDataSource.clearAllTables();
  }

  @override
  Future<AppVersionInfo> getAppVersionInfo() async {
    return const AppVersionInfo(version: '1.0.0', developer: 'Jesie Gapol');
  }
}
