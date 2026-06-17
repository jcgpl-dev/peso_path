import 'package:flutter/material.dart';
import 'package:peso_path/core/theme/app_colors.dart';
import 'package:peso_path/core/theme/app_spacing.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        // side: BorderSide(
        //   color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        //   width: 1,
        // ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color:
              // iconColor ??
              // (
              isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
        // ),
        title: Text(
          title,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle, style: theme.textTheme.bodyMedium),
        trailing:
            trailing ??
            Icon(
              Icons.chevron_right,
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            ),
      ),
    );
  }
}
