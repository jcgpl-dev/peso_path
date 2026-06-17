import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_radius.dart';
import 'package:peso_path/features/savings/domain/entities/savings_goal.dart';
import 'package:peso_path/features/savings/presentation/widgets/saving_goal_card.dart';
import 'package:peso_path/shared/widgets/app_confirmation_dialog.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../bloc/savings_bloc.dart';
import '../bloc/savings_event.dart';
import '../bloc/savings_state.dart';

class SavingsPage extends StatefulWidget {
  const SavingsPage({super.key});

  @override
  State<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends State<SavingsPage> {
  void _navigateToAddSavingsGoal(BuildContext context) {
    context.push('/add-savings-goal', extra: context.read<SavingsBloc>());
  }

  void _showEditDialog(BuildContext context, SavingsGoal goal) {
    final titleController = TextEditingController(text: goal.title);
    final targetController = TextEditingController(
      text: goal.targetAmount.toString(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AppBlocProviderContextFiller(
          parentContext: context,
          child: AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text(
              'Edit Goal',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(controller: titleController, label: 'Goal Name'),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  prefixText: '₱ ',
                  controller: targetController,
                  label: 'Target Amount',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newTitle = titleController.text.trim();
                  final newTarget = double.tryParse(
                    targetController.text.trim(),
                  );

                  if (newTitle.isNotEmpty &&
                      newTarget != null &&
                      newTarget > 0) {
                    context.read<SavingsBloc>().add(
                      UpdateGoalRequested(
                        goal.copyWith(title: newTitle, targetAmount: newTarget),
                      ),
                    );
                    Navigator.pop(dialogContext);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddFundsDialog(BuildContext context, String goalId) {
    final fundController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AppBlocProviderContextFiller(
          parentContext: context,
          child: AlertDialog(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            title: const Text(
              'Deposit Savings Funds',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter the amount to transfer into this goal:'),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: fundController,
                  label: 'Deposit Amount (₱)',
                  hintText: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Theme.of(context).hintColor),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final depositValue =
                      double.tryParse(fundController.text) ?? 0.0;
                  if (depositValue > 0) {
                    context.read<SavingsBloc>().add(
                      FundGoalRequested(goalId, depositValue),
                    );
                    Navigator.pop(dialogContext);
                  }
                },
                child: const Text('Deposit'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Savings Goals',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<SavingsBloc, SavingsState>(
        builder: (context, state) {
          if (state is SavingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SavingsError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is SavingsLoaded) {
            final goals = state.goals;
            if (goals.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.savings_outlined,
                        size: 72,
                        color: theme.hintColor.withAlpha(100),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      const Text(
                        'No Savings Targets Yet',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      PrimaryButton(
                        text: 'Create a Goal',
                        onPressed: () => _navigateToAddSavingsGoal(context),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async =>
                  context.read<SavingsBloc>().add(LoadSavingsGoals()),
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: goals.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return SavingsGoalCard(
                    goal: goal,
                    onAddFunds: () => _showAddFundsDialog(context, goal.id),
                    onEdit: () => _showEditDialog(context, goal),
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AppBlocProviderContextFiller(
                          parentContext: context,
                          child: AppConfirmationDialog(
                            title: 'Delete Goal',
                            message:
                                'Are you sure you want to delete "${goal.title}"?',
                            confirmText: 'Delete',
                            isDestructive: true,
                            onConfirm: () => context.read<SavingsBloc>().add(
                              DeleteGoalRequested(goal.id),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class AppBlocProviderContextFiller extends StatelessWidget {
  const AppBlocProviderContextFiller({
    super.key,
    required this.parentContext,
    required this.child,
  });
  final BuildContext parentContext;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SavingsBloc>.value(
      value: BlocProvider.of<SavingsBloc>(parentContext),
      child: child,
    );
  }
}
