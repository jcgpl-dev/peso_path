import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peso_path/core/theme/app_colors.dart';
import 'package:peso_path/shared/widgets/app_confirmation_dialog.dart';
import 'package:peso_path/shared/widgets/app_date_picker_tile.dart';
import 'package:peso_path/shared/widgets/app_dropdown_field.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

import '../../../../core/utils/date_formatter.dart';

import '../../domain/entities/transaction.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';

class EditTransactionPage extends StatefulWidget {
  const EditTransactionPage({super.key, required this.transaction});

  final Transaction transaction;

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  late final TextEditingController titleController;
  late final TextEditingController amountController;
  late final TextEditingController noteController;
  late String selectedCategory;
  late DateTime _selectedDate;

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

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AppConfirmationDialog(
        title: 'Delete Transaction',
        message:
            'Are you sure you want to delete "${widget.transaction.title}"?',
        confirmText: 'Delete',
        isDestructive: true,
        onConfirm: () {
          context.read<TransactionBloc>().add(
            DeleteTransactionRequested(widget.transaction.id),
          );
          // Navigate back after triggering the delete event
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.transaction.title);
    amountController = TextEditingController(
      text: widget.transaction.amount.toStringAsFixed(2),
    );
    noteController = TextEditingController(text: widget.transaction.note ?? '');

    _selectedDate =
        DateTime.tryParse(widget.transaction.transactionDate) ?? DateTime.now();

    final availableCategories = widget.transaction.type == 'expense'
        ? expenseCategories
        : incomeCategories;

    if (availableCategories.contains(widget.transaction.category)) {
      selectedCategory = widget.transaction.category;
    } else {
      selectedCategory = 'Others';
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final activeSemColor = widget.transaction.type == 'expense'
        ? AppColors.expense
        : AppColors.income;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: activeSemColor),
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

    final updatedTransaction = Transaction(
      id: widget.transaction.id,
      userId: widget.transaction.userId,
      title: title,
      amount: amount,
      type: widget.transaction.type,
      category: selectedCategory,
      note: noteController.text.trim(),
      transactionDate: _selectedDate.toIso8601String(),
      createdAt: widget.transaction.createdAt,
    );

    context.read<TransactionBloc>().add(
      UpdateTransactionRequested(updatedTransaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransactionBloc, TransactionState>(
      listener: (context, state) {
        if (state is TransactionUpdated || state is TransactionDeleted) {
          AppSnackbar.showSuccess(
            context,
            'Transaction processed successfully',
          );
          Navigator.pop(context);
        }
        if (state is TransactionFailure) {
          AppSnackbar.showError(context, state.message);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Edit Transaction'),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                ),
                // UPDATED: Now calls the confirmation dialog
                onPressed: () => _showDeleteConfirmation(context),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: titleController,
                    label: 'Title',
                    hintText: 'e.g., Grocery shopping, Jeepney fare',
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
                        (widget.transaction.type == 'expense'
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
                    hintText: 'Add extra details like shop name or split costs',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(text: 'Save Changes', onPressed: submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
