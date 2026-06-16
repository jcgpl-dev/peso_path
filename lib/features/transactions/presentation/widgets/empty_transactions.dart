import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class EmptyTransactions extends StatelessWidget {
  final double? iconSize;
  const EmptyTransactions({super.key, this.iconSize});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: iconSize ?? 72,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('No Transactions Yet', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tap the + button below to add your first transaction.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
