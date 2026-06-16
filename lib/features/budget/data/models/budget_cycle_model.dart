import '../../domain/entities/budget_cycle.dart';

class BudgetCycleModel extends BudgetCycle {
  const BudgetCycleModel({
    required super.id,
    required super.userId,
    required super.budgetAmount,
    required super.startDate,
    required super.endDate,
    required super.isActive,
    required super.createdAt,
  });

  factory BudgetCycleModel.fromMap(Map<String, dynamic> map) {
    return BudgetCycleModel(
      id: map['id'],
      userId: map['user_id'],
      budgetAmount: (map['budget_amount'] as num).toDouble(),
      startDate: map['start_date'],
      endDate: map['end_date'],
      isActive: map['is_active'] == 1,
      createdAt: map['created_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'budget_amount': budgetAmount,
      'start_date': startDate,
      'end_date': endDate,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt,
    };
  }
}
