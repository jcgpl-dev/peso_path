import '../entities/budget_cycle.dart';
import '../repositories/budget_repository.dart';

class GetActiveBudgetCycle {
  final BudgetRepository repository;

  GetActiveBudgetCycle(this.repository);

  Future<BudgetCycle?> call() {
    return repository.getActiveBudgetCycle();
  }
}
