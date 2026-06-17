import 'package:flutter/material.dart';
import '../../core/theme/app_radius.dart';

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final VoidCallback onConfirm;
  final bool isDestructive;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    required this.onConfirm,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text('Cancel', style: TextStyle(color: theme.hintColor)),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context, true);
          },
          child: Text(
            confirmText,
            style: TextStyle(
              color: isDestructive
                  ? theme.colorScheme.error
                  : theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
