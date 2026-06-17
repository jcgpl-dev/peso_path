import '../repositories/savings_repository.dart';

class AddFundsToGoal {
  final SavingsRepository repository;
  AddFundsToGoal(this.repository);

  Future<void> call(String goalId, double amount) =>
      repository.addFundsToGoal(goalId, amount);
}
