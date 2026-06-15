import 'package:flutter/material.dart';
import 'package:peso_path/core/theme/app_colors.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AppSpacing.lg),
                Image.asset(
                  'lib/assets/icons/ic-peso-path.png',
                  width: 80,
                  height: 80,
                ),
                SizedBox(height: AppSpacing.md),
                Text('Welcome Back!', style: AppTextStyles.displayLarge),

                const SizedBox(height: AppSpacing.md),

                // Text(title, style: AppTextStyles.headlineLarge),
                // const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
