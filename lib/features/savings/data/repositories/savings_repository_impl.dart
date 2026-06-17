import '../../domain/entities/savings_goal.dart';
import '../../domain/repositories/savings_repository.dart';
import '../datasources/savings_local_datasource.dart';

class SavingsRepositoryImpl implements SavingsRepository {
  final SavingsLocalDataSource localDataSource;

  SavingsRepositoryImpl(this.localDataSource);

  @override
  Future<List<SavingsGoal>> getSavingsGoals() =>
      localDataSource.getSavingsGoals();

  @override
  Future<void> createSavingsGoal(SavingsGoal goal) =>
      localDataSource.createSavingsGoal(goal);

  @override
  Future<void> addFundsToGoal(String goalId, double amount) =>
      localDataSource.addFundsToGoal(goalId, amount);
}
