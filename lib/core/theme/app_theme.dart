import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      fontFamily: 'Inter',

      scaffoldBackgroundColor: AppColors.background,

      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),

      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
    );
  }
}
