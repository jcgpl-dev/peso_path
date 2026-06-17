import 'package:flutter/material.dart';

class AppDatePickerTile extends StatelessWidget {
  const AppDatePickerTile({
    super.key,
    required this.label,
    required this.valueText,
    required this.onTap,
  });

  final String label;
  final String valueText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: theme.dividerColor),
          ),

          suffixIcon: Icon(
            Icons.calendar_today_rounded,
            size: 18,
            color: theme.hintColor.withAlpha(180),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(valueText, style: theme.textTheme.bodyLarge),
        ),
      ),
    );
  }
}
