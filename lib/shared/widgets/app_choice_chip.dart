import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';

class AppChoiceChip extends StatelessWidget {
  const AppChoiceChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dynamically resolve colors using your theme tokens
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final unselectedBg = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final unselectedBorder = isDark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return ChoiceChip(
      label: Text(label, overflow: TextOverflow.ellipsis),
      selected: isSelected,
      checkmarkColor: Colors.white,
      onSelected: onSelected,
      selectedColor: theme.colorScheme.primary,
      backgroundColor: unselectedBg,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: isSelected ? Colors.white : textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        side: BorderSide(
          color: isSelected ? Colors.transparent : unselectedBorder,
        ),
      ),
    );
  }
}
