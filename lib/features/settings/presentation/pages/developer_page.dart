import 'package:flutter/material.dart';
import 'package:peso_path/core/theme/app_colors.dart';
import 'package:peso_path/core/theme/app_spacing.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.md),
            // Profile Avatar / Placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),

                image: const DecorationImage(
                  image: AssetImage('lib/assets/images/dev-profile.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Jesie Gapol',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Developer',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // About Developer Card
            _buildInfoCard(
              context,
              title: 'About Me',
              child: Text(
                'Hi, I\'m Jesie! I am passionate about crafting highly optimized, clean-architecture mobile applications using Flutter and Dart. Peso Path was designed to deliver a robust, offline-first personal financial budgeting tool with zero user data tracking.',
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Tech Stack Section
            _buildInfoCard(
              context,
              title: 'Core Stack for Peso Path',
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  _buildTechChip(context, 'Flutter'),
                  _buildTechChip(context, 'Bloc / Cubit'),
                  _buildTechChip(context, 'Clean Architecture'),
                  _buildTechChip(context, 'SQLite / Sqflite'),
                  _buildTechChip(context, 'Get_It (DI)'),
                  _buildTechChip(context, 'Go_Router'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Contact / Link rows
            _buildInfoCard(
              context,
              title: 'Connect & Support',
              child: Column(
                children: [
                  _buildContactRow(
                    context,
                    Icons.email_outlined,
                    'Email',
                    'gapoljesie23@gmail.com',
                  ),
                  const Divider(height: AppSpacing.lg),
                  _buildContactRow(
                    context,
                    Icons.language_rounded,
                    'GitHub',
                    'github.com/jcgpl-dev',
                  ),
                  const Divider(height: AppSpacing.lg),
                  _buildContactRow(
                    context,
                    Icons.face,
                    'Facebook',
                    'facebook.com/jesieperasgapol',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }

  Widget _buildTechChip(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Chip(
      label: Text(label),
      backgroundColor: isDark
          ? AppColors.darkBorder
          : AppColors.lightBorder.withValues(alpha: 0.5),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildContactRow(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: AppSpacing.md),
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.primary),
        ),
      ],
    );
  }
}
