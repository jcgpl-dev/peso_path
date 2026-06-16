import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peso_path/shared/widgets/app_dropdown_field.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

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

  String selectedType = 'expense';

  String selectedCategory = 'Food';

  final expenseCategories = [
    'Food',
    'Transportation',
    'Bills',
    'Shopping',
    'Savings',
    'Others',
  ];

  final incomeCategories = [
    'Allowance',
    'Salary',
    'Scholarship',
    'Gift',
    'Side Hustle',
    'Others',
  ];

  List<String> get categories {
    return selectedType == 'income' ? incomeCategories : expenseCategories;
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
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
      type: selectedType,
      category: selectedCategory,
      note: noteController.text.trim(),
      transactionDate: DateTime.now().toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
    );

    context.read<TransactionBloc>().add(AddTransactionRequested(transaction));
  }

  @override
  Widget build(BuildContext context) {
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
          appBar: AppBar(title: Text('Add Transaction')),

          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  AppTextField(controller: titleController, label: 'Title'),

                  const SizedBox(height: AppSpacing.md),

                  AppTextField(
                    controller: amountController,
                    label: 'Amount',
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  AppDropdownField<String>(
                    label: 'Type',
                    value: selectedType,
                    items: const [
                      DropdownMenuItem(value: 'income', child: Text('Income')),
                      DropdownMenuItem(
                        value: 'expense',
                        child: Text('Expense'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;

                        selectedCategory = selectedType == 'income'
                            ? incomeCategories.first
                            : expenseCategories.first;
                      });
                    },
                  ),

                  const SizedBox(height: AppSpacing.md),
                  AppDropdownField<String>(
                    label: 'Category',
                    value: selectedCategory,
                    items: categories
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

                  AppTextField(controller: noteController, label: 'Note'),

                  const SizedBox(height: AppSpacing.xl),

                  PrimaryButton(text: 'Save Transaction', onPressed: submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
