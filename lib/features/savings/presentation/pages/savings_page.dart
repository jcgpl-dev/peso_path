import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_radius.dart';
import 'package:peso_path/features/savings/presentation/widgets/saving_goal_card.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Savings Goals',
          style: theme.textTheme.headlineMedium?.copyWith(
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
                      Text(
                        'No Savings Targets Yet',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Create your first financial milestone goal to isolate and park unspent cash balances safely.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                        ),
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
              onRefresh: () async {
                context.read<SavingsBloc>().add(LoadSavingsGoals());
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: goals.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final goal = goals[index];
                  return SavingsGoalCard(
                    goal: goal,
                    onAddFunds: () => _showAddFundsDialog(context, goal.id),
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
                const Text(
                  'Enter the cash amount to transfer out of your active cycle spending budget and into this goal target:',
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: fundController,
                  label: 'Deposit Amount (₱)',
                  hintText: '0.00',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textInputAction: TextInputAction.done,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
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
    return BlocProvider.value(
      value: parentContext.read<SavingsBloc>(),
      child: child,
    );
  }
}
