import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peso_path/core/theme/app_colors.dart';
import 'package:peso_path/core/theme/app_radius.dart';
import 'package:peso_path/core/theme/app_text_styles.dart';
import 'package:peso_path/shared/widgets/app_date_picker_tile.dart';
import 'package:peso_path/shared/widgets/app_dropdown_field.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

import '../../../../core/utils/date_formatter.dart';

import '../../domain/entities/transaction.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();

  String transactionType = 'expense';
  String selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();

  final expenseCategories = [
    'Food',
    'Transportation',
    'Bills',
    'Shopping',
    'Savings',
    'Others',
  ];
  final incomeCategories = [
    'Salary',
    'Freelance',
    'Investments',
    'Allowance',
    'Others',
  ];

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: transactionType == 'expense'
                  ? AppColors.expense
                  : AppColors.income,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void submit() {
    final title = titleController.text.trim();
    final amount = double.tryParse(amountController.text.trim());

    if (title.isEmpty || amount == null || amount <= 0) {
      AppSnackbar.showError(context, 'Please fill all fields properly');
      return;
    }

    final transaction = Transaction(
      id: const Uuid().v4(),
      userId: '',
      title: title,
      amount: amount,
      type: transactionType,
      category: selectedCategory,
      note: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
      transactionDate: _selectedDate.toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
    );

    context.read<TransactionBloc>().add(AddTransactionRequested(transaction));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;
    final activeSemColor = transactionType == 'expense'
        ? AppColors.expense
        : AppColors.income;

    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionAdded) {
          AppSnackbar.showSuccess(context, 'Transaction added successfully');
          Navigator.pop(context);
        }
        if (state is TransactionFailure) {
          AppSnackbar.showError(context, state.message);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Add Transaction')),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildTypeSegment(
                          'expense',
                          'Expense',
                          AppColors.expense,
                        ),
                        _buildTypeSegment('income', 'Income', AppColors.income),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  AppTextField(
                    controller: titleController,
                    label: 'Title',
                    hintText: transactionType == 'expense'
                        ? 'e.g., Grocery shopping, Jeepney fare'
                        : 'e.g., Monthly salary, Side hustle payout',
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    prefixText: '₱ ',
                    controller: amountController,
                    label: 'Amount',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    hintText: '0.00',
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppDropdownField<String>(
                    label: 'Category',
                    value: selectedCategory,
                    items:
                        (transactionType == 'expense'
                                ? expenseCategories
                                : incomeCategories)
                            .map(
                              (e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppDatePickerTile(
                    label: 'Transaction Date',
                    valueText: _selectedDate.toReadableString(),
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    controller: noteController,
                    label: 'Note (Optional)',
                    hintText: 'Add extra details...',
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(
                        context,
                      ).colorScheme.copyWith(primary: activeSemColor),
                    ),
                    child: PrimaryButton(
                      text:
                          'Save ${transactionType == 'expense' ? 'Expense' : 'Income'}',
                      onPressed: submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSegment(String type, String label, Color activeColor) {
    final isSelected = transactionType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (transactionType != type) {
            setState(() {
              transactionType = type;
              selectedCategory = type == 'expense' ? 'Food' : 'Salary';
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? Colors.white
                  : (Theme.of(context).brightness == Brightness.dark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
