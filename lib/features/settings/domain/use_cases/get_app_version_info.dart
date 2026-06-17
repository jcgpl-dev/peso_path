import 'package:peso_path/features/settings/domain/entities/app_version_info.dart';
import 'package:peso_path/features/settings/domain/repositories/settings_repository.dart';

class GetAppVersionInfo {
  final SettingsRepository repository;

  GetAppVersionInfo(this.repository);

  Future<AppVersionInfo> call() async {
    return await repository.getAppVersionInfo();
  }
}
