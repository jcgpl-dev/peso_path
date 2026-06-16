import 'package:flutter/material.dart';
import 'package:peso_path/core/theme/app_text_styles.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Peso Path',
                style: AppTextStyles.brandTitle.copyWith(
                  color: colorScheme.primary,
                ),
              ),
              Text(
                'Your path to smarter spending',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }
}
