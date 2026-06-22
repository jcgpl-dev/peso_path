import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/app_choice_chip.dart';
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
  String _selectedPreset = 'Custom';

  @override
  void initState() {
    super.initState();
    _applyPreset('Next 30 Days');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BudgetBloc>().add(LoadActiveBudgetCycle());
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _prefillFromCycle(BudgetCycle cycle) {
    if (_prefilledCycleId == cycle.id) return;
    _prefilledCycleId = cycle.id;
    amountController.text = cycle.budgetAmount.toStringAsFixed(2);
    startDate = DateTime.parse(cycle.startDate);
    endDate = DateTime.parse(cycle.endDate);
    _selectedPreset = 'Custom';
    setState(() {});
  }

  void _applyPreset(String preset) {
    final now = DateTime.now();
    setState(() {
      _selectedPreset = preset;
      if (preset == 'This Month') {
        startDate = DateTime(now.year, now.month, 1);
        endDate = DateTime(
          now.year,
          now.month + 1,
          1,
        ).subtract(const Duration(days: 1));
      } else if (preset == 'Next 30 Days') {
        startDate = DateTime(now.year, now.month, now.day);

        endDate = DateTime(now.year, now.month + 1, now.day);
      }
    });
  }

  void _submitForm() {
    if (amountController.text.isEmpty || startDate == null || endDate == null) {
      return;
    }

    final amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount <= 0) return;

    if (_prefilledCycleId != null) {
      context.read<BudgetBloc>().add(
        UpdateBudgetCycleRequested(
          id: _prefilledCycleId!,
          budgetAmount: amount,
          startDate: startDate!,
          endDate: endDate!,
        ),
      );
    } else {
      context.read<BudgetBloc>().add(
        CreateBudgetCycleRequested(
          budgetAmount: amount,
          startDate: startDate!,
          endDate: endDate!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = _prefilledCycleId != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Modify Active Budget' : 'New Budget Setup'),
        ),
        body: BlocConsumer<BudgetBloc, BudgetState>(
          listener: (context, state) {
            if (state is BudgetLoaded) {
              _prefillFromCycle(state.cycle);
            }
            if (state is BudgetCreated || state is BudgetUpdated) {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/dashboard');
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppTextField(
                    controller: amountController,
                    label: isEditing
                        ? 'Adjust Budget Limit'
                        : 'Budget Target Amount',
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    prefixText: '₱ ',
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Text(
                    'Quick Duration Presets',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.outline,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      // Swapped 'Next Month' string directly here for 'Next 30 Days'
                      children: ['Next 30 Days', 'This Month', 'Custom'].map((
                        preset,
                      ) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: AppChoiceChip(
                            label: preset,
                            isSelected: _selectedPreset == preset,
                            onSelected: (selected) {
                              if (selected) {
                                if (preset == 'Custom') {
                                  setState(() => _selectedPreset = 'Custom');
                                } else {
                                  _applyPreset(preset);
                                }
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    color: colorScheme.surfaceContainerLow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.date_range_rounded,
                            color: colorScheme.primary,
                          ),
                          title: const Text(
                            'Starts On',
                            style: TextStyle(fontSize: 12),
                          ),
                          subtitle: Text(
                            startDate == null
                                ? 'Select Date'
                                : startDate.toString().split(' ')[0],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              firstDate: DateTime(2025),
                              lastDate: DateTime(2100),
                              initialDate: startDate ?? DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                startDate = picked;
                                _selectedPreset = 'Custom';
                                if (endDate == null ||
                                    endDate!.isBefore(picked)) {
                                  endDate = DateTime(
                                    picked.year,
                                    picked.month + 1,
                                    picked.day,
                                  );
                                }
                              });
                            }
                          },
                        ),
                        Divider(
                          height: 1,
                          indent: 56,
                          color: colorScheme.surfaceContainerHigh,
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.flag_rounded,
                            color: colorScheme.error,
                          ),
                          title: const Text(
                            'Ends On',
                            style: TextStyle(fontSize: 12),
                          ),
                          subtitle: Text(
                            endDate == null
                                ? 'Select Date'
                                : endDate.toString().split(' ')[0],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              firstDate: startDate ?? DateTime(2025),
                              lastDate: DateTime(2100),
                              initialDate:
                                  endDate ?? startDate ?? DateTime.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                endDate = picked;
                                _selectedPreset = 'Custom';
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  PrimaryButton(
                    text: isEditing
                        ? 'Save Financial Profile'
                        : 'Initialize Budget Plan',
                    isLoading: state is BudgetLoading,
                    onPressed: _submitForm,
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
