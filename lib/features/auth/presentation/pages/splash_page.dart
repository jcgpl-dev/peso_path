import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_colors.dart';
import 'package:peso_path/core/theme/app_spacing.dart';
import 'package:peso_path/core/theme/app_text_styles.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      context.go('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/icons/ic-peso-path.png',
              width: 80,
              height: 80,
            ),
            SizedBox(height: AppSpacing.md),
            const Text('Peso Path', style: AppTextStyles.headlineLargeDark),
          ],
        ),
      ),
    );
  }
}
