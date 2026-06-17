import 'package:equatable/equatable.dart';
import 'package:peso_path/features/savings/domain/entities/savings_goal.dart';

abstract class SavingsEvent extends Equatable {
  const SavingsEvent();
  @override
  List<Object?> get props => [];
}

class LoadSavingsGoals extends SavingsEvent {}

class CreateGoalRequested extends SavingsEvent {
  final String title;
  final double targetAmount;
  const CreateGoalRequested(this.title, this.targetAmount);
}

class FundGoalRequested extends SavingsEvent {
  final String goalId;
  final double amount;
  const FundGoalRequested(this.goalId, this.amount);
}

class DeleteGoalRequested extends SavingsEvent {
  final String goalId;
  const DeleteGoalRequested(this.goalId);
}

class UpdateGoalRequested extends SavingsEvent {
  final SavingsGoal goal;
  const UpdateGoalRequested(this.goal);
}
