import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_spacing.dart';

import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';

import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';

class BudgetSetupPage extends StatefulWidget {
  const BudgetSetupPage({super.key});

  @override
  State<BudgetSetupPage> createState() => _BudgetSetupPageState();
}

class _BudgetSetupPageState extends State<BudgetSetupPage> {
  final amountController = TextEditingController();

  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Setup')),
      body: BlocConsumer<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetCreated) {
            context.go('/dashboard');
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                AppTextField(
                  controller: amountController,
                  label: 'Budget Amount',
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 16),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    startDate == null
                        ? 'Select Start Date'
                        : startDate.toString().split(' ')[0],
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                    );

                    if (picked != null) {
                      setState(() => startDate = picked);
                    }
                  },
                ),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    endDate == null
                        ? 'Select End Date'
                        : endDate.toString().split(' ')[0],
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2100),
                      initialDate: DateTime.now(),
                    );

                    if (picked != null) {
                      setState(() => endDate = picked);
                    }
                  },
                ),

                const SizedBox(height: AppSpacing.lg),

                PrimaryButton(
                  text: 'Create Budget',
                  isLoading: state is BudgetLoading,
                  onPressed: () {
                    if (startDate == null || endDate == null) {
                      return;
                    }

                    context.read<BudgetBloc>().add(
                      CreateBudgetCycleRequested(
                        budgetAmount: double.parse(amountController.text),
                        startDate: startDate!,
                        endDate: endDate!,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
