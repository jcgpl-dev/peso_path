import 'package:equatable/equatable.dart';

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
