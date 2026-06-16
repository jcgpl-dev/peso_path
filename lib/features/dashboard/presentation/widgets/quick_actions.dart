import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: Theme.of(context).textTheme.titleLarge),

        const SizedBox(height: AppSpacing.md),

        Row(
          children: const [
            Expanded(
              child: _ActionButton(icon: Icons.add, label: 'Expense'),
            ),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: _ActionButton(icon: Icons.arrow_downward, label: 'Income'),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: colorScheme.primary,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text(label),
          ],
        ),
      ),
    );
  }
}
