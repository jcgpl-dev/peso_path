import '../entities/savings_goal.dart';
import '../repositories/savings_repository.dart';

class GetSavingsGoals {
  final SavingsRepository repository;
  GetSavingsGoals(this.repository);

  Future<List<SavingsGoal>> call() => repository.getSavingsGoals();
}
