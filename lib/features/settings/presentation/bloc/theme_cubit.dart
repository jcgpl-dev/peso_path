import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peso_path/features/settings/domain/use_cases/manage_theme.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final LoadThemePreference loadThemePreference;
  final SaveThemePreference saveThemePreference;

  ThemeCubit({
    required this.loadThemePreference,
    required this.saveThemePreference,
  }) : super(ThemeMode.light) {
    _loadPersistedTheme();
  }

  void _loadPersistedTheme() async {
    final isDark = await loadThemePreference();
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme(bool isDark) async {
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
    await saveThemePreference(isDark);
  }
}
