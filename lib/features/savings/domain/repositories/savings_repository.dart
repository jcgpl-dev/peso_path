import '../entities/savings_goal.dart';

abstract class SavingsRepository {
  Future<List<SavingsGoal>> getSavingsGoals();
  Future<void> createSavingsGoal(SavingsGoal goal);
  Future<void> addFundsToGoal(String goalId, double amount);
  Future<void> deleteSavingsGoal(String goalId);
  Future<void> updateSavingsGoal(SavingsGoal goal);
}
