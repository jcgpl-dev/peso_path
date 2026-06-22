import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_card.dart';

class MonthlyOverviewCard extends StatelessWidget {
  const MonthlyOverviewCard({
    super.key,
    required this.budgetAmount,
    required this.totalSpent,
    required this.remainingBudget,
  });

  final double budgetAmount;
  final double totalSpent;
  final double remainingBudget;

  @override
  Widget build(BuildContext context) {
    final double percentage = budgetAmount > 0
        ? (totalSpent / budgetAmount).clamp(0.0, 1.0)
        : 0.0;
    final double displayPercentage = percentage * 100;

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final linkColor = isDarkMode ? AppColors.darkLink : AppColors.lightLink;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Budget Overview',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => context.push('/budget-setup'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View details',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: linkColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.xl),

          // Metrics Grid Row
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _MetricColumn(
                    title: 'Budget',
                    value: budgetAmount,
                    icon: PhosphorIcons.wallet(PhosphorIconsStyle.bold),
                    iconColor: const Color(0xFF10B981),
                    valueColor: const Color(0xFF10B981),
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey.withValues(alpha: 0.2),
                  thickness: 1,
                  indent: 4,
                  endIndent: 4,
                ),
                Expanded(
                  child: _MetricColumn(
                    title: 'Spent',
                    value: totalSpent,
                    icon: PhosphorIcons.arrowDown(PhosphorIconsStyle.bold),
                    iconColor: const Color(0xFFEF4444), // Crimson Red
                    valueColor: const Color(0xFFEF4444),
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey.withValues(alpha: 0.2),
                  thickness: 1,
                  indent: 4,
                  endIndent: 4,
                ),
                Expanded(
                  child: _MetricColumn(
                    title: 'Remaining',
                    value: remainingBudget,
                    icon: PhosphorIcons.chartPieSlice(PhosphorIconsStyle.bold),
                    iconColor: const Color(0xFF059669), // Rich Deep Green
                    valueColor: const Color(0xFF059669),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.xl),
          Divider(color: Colors.grey.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: AppSpacing.lg),

          // Lower Section: Progress Title Header bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spending Progress',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${displayPercentage.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.sm),

          // Custom Linear Tracker Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 8,
              backgroundColor: const Color(
                0xFFF1F5F9,
              ), // Light background track
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF10B981),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Microcopy Descriptive Context Footer
          Text(
            "You've spent ${displayPercentage.toStringAsFixed(1)}% of your budget",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF64748B), // Slate Muted Gray text
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.valueColor,
  });

  final String title;
  final double value;
  final IconData icon;
  final Color iconColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ring Base Wrapped Circular Icon Placements
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),

        const SizedBox(height: AppSpacing.xs),

        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          '₱${value.toStringAsFixed(2)}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
