import 'package:peso_path/core/database/database_helper.dart';

import '../../../../core/session/current_user.dart';
import '../../../budget/data/models/budget_cycle_model.dart';
import '../../../transactions/data/models/transaction_model.dart';
import '../models/dashboard_summary_model.dart';

class DashboardLocalDataSource {
  final CurrentUser currentUser;

  DashboardLocalDataSource(this.currentUser);

  Future<DashboardSummaryModel> getDashboardSummary() async {
    final db = await DatabaseHelper.instance.database;

    final userId = currentUser.requireUserId();

    final cycleResult = await db.query(
      'budget_cycles',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
      limit: 1,
    );

    // No active budget cycle yet
    if (cycleResult.isEmpty) {
      return DashboardSummaryModel(
        budgetAmount: 0,
        totalSpent: 0,
        remainingBudget: 0,
        safeBudget: 0,
        recentTransactions: [],
        endDate: DateTime.now(),
      );
    }

    final cycle = BudgetCycleModel.fromMap(cycleResult.first);

    // Transactions inside active budget cycle only
    final transactionMaps = await db.query(
      'transactions',
      where: 'user_id = ? AND transaction_date >= ? AND transaction_date <= ?',
      whereArgs: [userId, cycle.startDate, cycle.endDate],
    );

    double totalSpent = 0;

    for (final transaction in transactionMaps) {
      if (transaction['type'] == 'expense') {
        totalSpent += (transaction['amount'] as num).toDouble();
      }
    }

    final remainingBudget = cycle.budgetAmount - totalSpent;

    final now = DateTime.now();

    final endDate = DateTime.parse(cycle.endDate);

    final remainingDays = endDate.difference(now).inDays + 1;

    final safeBudget = remainingBudget > 0 && remainingDays > 0
        ? remainingBudget / remainingDays
        : 0.0;

    final recentMaps = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'transaction_date DESC',
      limit: 5,
    );

    final recentTransactions = recentMaps
        .map(TransactionModel.fromMap)
        .toList();

    return DashboardSummaryModel(
      budgetAmount: cycle.budgetAmount,
      totalSpent: totalSpent,
      remainingBudget: remainingBudget,
      safeBudget: safeBudget,
      recentTransactions: recentTransactions,
      endDate: endDate,
    );
  }
}
