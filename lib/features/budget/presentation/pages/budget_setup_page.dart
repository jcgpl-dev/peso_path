import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/budget_bloc.dart';
import '../bloc/budget_event.dart';
import '../bloc/budget_state.dart';
import '../../domain/entities/budget_cycle.dart';

class BudgetSetupPage extends StatefulWidget {
  const BudgetSetupPage({super.key});

  @override
  State<BudgetSetupPage> createState() => _BudgetSetupPageState();
}

class _BudgetSetupPageState extends State<BudgetSetupPage> {
  final amountController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  String? _prefilledCycleId;

  void _prefillFromCycle(BudgetCycle cycle) {
    if (_prefilledCycleId == cycle.id) return;

    _prefilledCycleId = cycle.id;
    amountController.text = cycle.budgetAmount.toStringAsFixed(2);
    startDate = DateTime.parse(cycle.startDate);
    endDate = DateTime.parse(cycle.endDate);
    setState(() {});
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, now.day);
    endDate = DateTime(now.year, now.month + 1, now.day);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BudgetBloc>().add(LoadActiveBudgetCycle());
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Budget Setup')),
        body: BlocConsumer<BudgetBloc, BudgetState>(
          listener: (context, state) {
            if (state is BudgetLoaded) {
              _prefillFromCycle(state.cycle);
            }

            if (state is BudgetCreated) {
              context.go('/dashboard');
            }

            if (state is BudgetUpdated) {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/dashboard');
              }
            }
          },
          builder: (context, state) {
            if (state is BudgetLoaded) {
              return Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      controller: amountController,
                      label: 'Current Budget',
                      keyboardType: TextInputType.number,
                      prefixText: '₱ ',
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
                          initialDate: startDate ?? DateTime.now(),
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
                          initialDate: endDate ?? startDate ?? DateTime.now(),
                        );
                        if (picked != null) {
                          setState(() => endDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PrimaryButton(
                      text: 'Save Changes',
                      onPressed: () {
                        if (startDate == null || endDate == null) {
                          return;
                        }
                        context.read<BudgetBloc>().add(
                          UpdateBudgetCycleRequested(
                            id: state.cycle.id,
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
            }

            return Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  AppTextField(
                    controller: amountController,
                    label: 'Budget Amount',
                    prefixText: '₱ ',
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
                        initialDate: startDate ?? DateTime.now(),
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
                        initialDate: endDate ?? startDate ?? DateTime.now(),
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
                      if (amountController.text.isEmpty ||
                          startDate == null ||
                          endDate == null) {
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
      ),
    );
  }
}
