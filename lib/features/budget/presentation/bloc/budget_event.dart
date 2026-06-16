import '../../domain/entities/budget_cycle.dart';

abstract class BudgetEvent {}

class LoadActiveBudget extends BudgetEvent {}

class CreateBudgetRequested extends BudgetEvent {
  final BudgetCycle cycle;

  CreateBudgetRequested(this.cycle);
}

class UpdateBudgetRequested extends BudgetEvent {
  final BudgetCycle cycle;

  UpdateBudgetRequested(this.cycle);
}
