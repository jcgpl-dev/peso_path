import '../../domain/entities/budget_cycle.dart';
import '../../domain/repositories/budget_repository.dart';

import '../datasources/budget_local_datasource.dart';
import '../models/budget_cycle_model.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetLocalDataSource localDataSource;

  BudgetRepositoryImpl(this.localDataSource);

  @override
  Future<void> createBudgetCycle(BudgetCycle cycle) async {
    await localDataSource.createBudgetCycle(
      BudgetCycleModel(
        id: cycle.id,
        userId: cycle.userId,
        budgetAmount: cycle.budgetAmount,
        startDate: cycle.startDate,
        endDate: cycle.endDate,
        isActive: cycle.isActive,
        createdAt: cycle.createdAt,
      ),
    );
  }

  @override
  Future<void> updateBudgetCycle(BudgetCycle cycle) async {
    await localDataSource.updateBudgetCycle(
      BudgetCycleModel(
        id: cycle.id,
        userId: cycle.userId,
        budgetAmount: cycle.budgetAmount,
        startDate: cycle.startDate,
        endDate: cycle.endDate,
        isActive: cycle.isActive,
        createdAt: cycle.createdAt,
      ),
    );
  }

  @override
  Future<BudgetCycle?> getActiveBudgetCycle() {
    return localDataSource.getActiveBudgetCycle();
  }
}
