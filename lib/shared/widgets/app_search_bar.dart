import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.hintText = 'Search...',
    required this.onChanged,
    this.contentPadding,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final EdgeInsetsGeometry? contentPadding;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleTextChange);
    _controller.dispose();
    super.dispose();
  }

  void _handleTextChange() {
    final text = _controller.text;
    widget.onChanged(text);

    if (text.isNotEmpty != _hasText) {
      setState(() {
        _hasText = text.isNotEmpty;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Resolve context-aware border and active color variables dynamically
    final borderColor = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final hintStyle = theme.textTheme.bodyMedium;

    return TextField(
      controller: _controller,
      style: theme.textTheme.bodyLarge, // Uses Inter bodyLarge styled per theme
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: hintStyle,
        filled: true,
        fillColor: theme
            .colorScheme
            .surface, // Clean canvas fallback matching surface context
        prefixIcon: Icon(
          Icons.search_rounded,
          color: theme
              .textTheme
              .bodyMedium
              ?.color, // Syncs icon color with secondary text token
          size: 22,
        ),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.clear_rounded),
                iconSize: 20,
                color: theme.textTheme.bodyMedium?.color,
                onPressed: () {
                  _controller.clear();
                  FocusScope.of(context).unfocus();
                },
              )
            : null,
        contentPadding:
            widget.contentPadding ??
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
        // Uniform layout styling matching radii
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
