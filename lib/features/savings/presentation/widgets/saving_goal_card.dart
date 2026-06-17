import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/savings_goal.dart';

class SavingsGoalCard extends StatelessWidget {
  const SavingsGoalCard({
    super.key,
    required this.goal,
    required this.onAddFunds,
  });

  final SavingsGoal goal;
  final VoidCallback onAddFunds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompleted = goal.isAchieved;
    final progressPercentage = (goal.progress * 100)
        .clamp(0.0, 100.0)
        .toStringAsFixed(0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                onPressed: onAddFunds,
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary.withAlpha(30),
                  foregroundColor: theme.colorScheme.primary,
                ),
                icon: const Icon(Icons.add, size: 20),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '₱${goal.currentAmount.toStringAsFixed(2)} Saved',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isCompleted ? Colors.green : theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Target: ₱${goal.targetAmount.toStringAsFixed(2)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: goal.progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: theme.dividerColor.withAlpha(100),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? Colors.green : theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$progressPercentage%',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
