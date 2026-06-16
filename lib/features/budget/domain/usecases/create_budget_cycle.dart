import '../entities/budget_cycle.dart';
import '../repositories/budget_repository.dart';

class CreateBudgetCycle {
  final BudgetRepository repository;

  CreateBudgetCycle(this.repository);

  Future<void> call(BudgetCycle cycle) {
    return repository.createBudgetCycle(cycle);
  }
}
