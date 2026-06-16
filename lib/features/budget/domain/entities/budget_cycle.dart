class BudgetCycle {
  final String id;

  final String userId;

  final double budgetAmount;

  final String startDate;

  final String endDate;

  final bool isActive;
  final String createdAt;

  const BudgetCycle({
    required this.id,
    required this.userId,
    required this.budgetAmount,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.createdAt,
  });
}
