import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_text_styles.dart';
import 'package:peso_path/core/utils/greeting_util.dart';

class DashboardHeader extends StatelessWidget {
  final String userFullname;
  const DashboardHeader({super.key, required this.userFullname});

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
              Text(getGreeting(), style: textTheme.bodyMedium),
              Text(
                "$userFullname!",
                style: AppTextStyles.brandTitle.copyWith(
                  color: colorScheme.primary,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {
            context.push('/profile');
          },
          child: CircleAvatar(
            radius: 24,
            backgroundColor: colorScheme.primary.withAlpha(40),
            child: Icon(Icons.person_rounded, color: colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
