import 'package:equatable/equatable.dart';

abstract class BudgetEvent extends Equatable {
  const BudgetEvent();

  @override
  List<Object?> get props => [];
}

class LoadActiveBudgetCycle extends BudgetEvent {}

class CreateBudgetCycleRequested extends BudgetEvent {
  final double budgetAmount;
  final DateTime startDate;
  final DateTime endDate;

  const CreateBudgetCycleRequested({
    required this.budgetAmount,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [budgetAmount, startDate, endDate];
}

class UpdateBudgetCycleRequested extends BudgetEvent {
  final String id;
  final double budgetAmount;
  final DateTime startDate;
  final DateTime endDate;

  const UpdateBudgetCycleRequested({
    required this.id,
    required this.budgetAmount,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [id, budgetAmount, startDate, endDate];
}
