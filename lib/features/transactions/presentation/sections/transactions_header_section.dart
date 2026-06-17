import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_choice_chip.dart';
import '../../../../shared/widgets/app_search_bar.dart';

class TransactionsHeaderSection extends StatelessWidget {
  const TransactionsHeaderSection({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    required this.onSearchChanged,
    required this.onCategorySelected,
    required this.categories,
  });

  final String searchQuery;
  final String selectedCategory;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onCategorySelected;
  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          AppSearchBar(
            hintText: 'Search transactions...',
            onChanged: onSearchChanged,
          ),
          const SizedBox(height: AppSpacing.sm),

          // Category Filter Ribbon
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.xs),
              itemBuilder: (context, index) {
                final category = categories[index];
                return AppChoiceChip(
                  label: category,
                  isSelected: selectedCategory == category,
                  onSelected: (selected) {
                    if (selected) onCategorySelected(category);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
      ),
    );
  }
}
