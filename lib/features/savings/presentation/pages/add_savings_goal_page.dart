import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_snackbar.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/savings_bloc.dart';
import '../bloc/savings_event.dart';
import '../bloc/savings_state.dart';

class AddSavingsGoalPage extends StatefulWidget {
  const AddSavingsGoalPage({super.key});

  @override
  State<AddSavingsGoalPage> createState() => _AddSavingsGoalPageState();
}

class _AddSavingsGoalPageState extends State<AddSavingsGoalPage> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }

  void submit() {
    final title = titleController.text.trim();
    final targetAmount = double.tryParse(amountController.text.trim());

    if (title.isEmpty || targetAmount == null || targetAmount <= 0) {
      AppSnackbar.showError(context, 'Please fill all fields properly');
      return;
    }

    context.read<SavingsBloc>().add(CreateGoalRequested(title, targetAmount));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SavingsBloc, SavingsState>(
      listener: (context, state) {
        if (state is SavingsOperationSuccess) {
          AppSnackbar.showSuccess(context, 'Savings goal created successfully');
          Navigator.pop(context);
        }
        if (state is SavingsError) {
          AppSnackbar.showError(context, state.message);
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: const Text('Add Savings Goal')),
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: titleController,
                    label: 'Goal Name',
                    hintText: 'e.g., Emergency Fund, New Laptop, Travel Bag',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    prefixText: '₱ ',
                    controller: amountController,
                    label: 'Target Amount',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    hintText: '0.00',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  PrimaryButton(text: 'Save Savings Goal', onPressed: submit),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
