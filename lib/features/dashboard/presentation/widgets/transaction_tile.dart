import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../transactions/domain/entities/transaction.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final Transaction transaction;

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;

      case 'transportation':
        return Icons.directions_bus_rounded;

      case 'bills':
        return Icons.receipt_long_rounded;

      case 'shopping':
        return Icons.shopping_bag_rounded;

      case 'savings':
        return Icons.savings_rounded;

      default:
        return Icons.more_horiz_rounded;
    }
  }

  Color _categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;

      case 'transportation':
        return Colors.blue;

      case 'bills':
        return Colors.red;

      case 'shopping':
        return Colors.purple;

      case 'savings':
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(transaction.category);
    final icon = _categoryIcon(transaction.category);

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),

        const SizedBox(width: AppSpacing.md),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              const SizedBox(height: 2),

              Text(
                transaction.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        Text(
          '-₱${transaction.amount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
