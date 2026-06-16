import '../entities/budget_cycle.dart';

abstract class BudgetRepository {
  Future<void> createBudgetCycle(BudgetCycle cycle);

  Future<void> updateBudgetCycle(BudgetCycle cycle);

  Future<BudgetCycle?> getActiveBudgetCycle();
}
