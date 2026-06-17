import 'package:peso_path/features/settings/domain/entities/app_version_info.dart';

abstract class SettingsState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final AppVersionInfo versionInfo;
  const SettingsLoaded(this.versionInfo);
}

class DataWipeSuccess extends SettingsState {}

class SettingsFailure extends SettingsState {
  final String message;
  const SettingsFailure(this.message);
}
