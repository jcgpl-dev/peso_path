import '../entities/budget_cycle.dart';
import '../repositories/budget_repository.dart';

class UpdateBudgetCycle {
  final BudgetRepository repository;

  UpdateBudgetCycle(this.repository);

  Future<void> call(BudgetCycle cycle) {
    return repository.updateBudgetCycle(cycle);
  }
}
