import 'package:equatable/equatable.dart';
import '../../domain/entities/savings_goal.dart';

abstract class SavingsState extends Equatable {
  const SavingsState();
  @override
  List<Object?> get props => [];
}

class SavingsInitial extends SavingsState {}

class SavingsLoading extends SavingsState {}

class SavingsOperationSuccess extends SavingsState {}

class SavingsLoaded extends SavingsState {
  final List<SavingsGoal> goals;
  const SavingsLoaded(this.goals);
  @override
  List<Object?> get props => [goals];
}

class SavingsError extends SavingsState {
  final String message;
  const SavingsError(this.message);
}
