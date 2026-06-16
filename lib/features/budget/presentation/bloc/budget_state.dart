import '../../domain/entities/budget_cycle.dart';

abstract class BudgetState {}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final BudgetCycle? cycle;

  BudgetLoaded(this.cycle);
}

class BudgetCreated extends BudgetState {}

class BudgetUpdated extends BudgetState {}

class BudgetFailure extends BudgetState {
  final String message;

  BudgetFailure(this.message);
}
