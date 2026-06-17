import 'package:equatable/equatable.dart';

class SavingsGoal extends Equatable {
  final String id;
  final String userId;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final String createdAt;

  const SavingsGoal({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.createdAt,
  });

  double get progress => targetAmount > 0 ? currentAmount / targetAmount : 0.0;
  bool get isAchieved => currentAmount >= targetAmount;

  SavingsGoal copyWith({
    String? id,
    String? userId,
    String? title,
    double? targetAmount,
    double? currentAmount,
    String? createdAt,
  }) {
    return SavingsGoal(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    title,
    targetAmount,
    currentAmount,
    createdAt,
  ];
}
