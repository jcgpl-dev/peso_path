import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peso_path/features/settings/domain/use_cases/clear_all_user_data.dart';
import 'package:peso_path/features/settings/domain/use_cases/get_app_version_info.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetAppVersionInfo getAppVersionInfo;
  final ClearAllUserData clearAllUserData;

  SettingsBloc({
    required this.getAppVersionInfo,
    required this.clearAllUserData,
  }) : super(SettingsInitial()) {
    on<LoadSettingsInfoRequested>(_onLoadSettingsInfo);
    on<WipeAllUserDataRequested>(_onWipeAllUserData);
  }

  Future<void> _onLoadSettingsInfo(
    LoadSettingsInfoRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      final info = await getAppVersionInfo();
      emit(SettingsLoaded(info));
    } catch (e) {
      emit(SettingsFailure(e.toString()));
    }
  }

  Future<void> _onWipeAllUserData(
    WipeAllUserDataRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    try {
      await clearAllUserData();
      emit(DataWipeSuccess());

      // Reload version layout parameters cleanly
      final info = await getAppVersionInfo();
      emit(SettingsLoaded(info));
    } catch (e) {
      emit(SettingsFailure(e.toString()));
    }
  }
}
