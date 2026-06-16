import 'package:equatable/equatable.dart';

import '../../domain/entities/budget_cycle.dart';

abstract class BudgetState extends Equatable {
  const BudgetState();

  @override
  List<Object?> get props => [];
}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetCreated extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final BudgetCycle cycle;

  const BudgetLoaded(this.cycle);

  @override
  List<Object?> get props => [cycle];
}

class BudgetError extends BudgetState {
  final String message;

  const BudgetError(this.message);

  @override
  List<Object?> get props => [message];
}

class BudgetUpdated extends BudgetState {}
