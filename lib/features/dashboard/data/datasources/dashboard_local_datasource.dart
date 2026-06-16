import 'package:peso_path/core/database/database_helper.dart';

import '../../../transactions/data/models/transaction_model.dart';
import '../models/dashboard_summary_model.dart';

class DashboardLocalDataSource {
  Future<DashboardSummaryModel> getDashboardSummary() async {
    final db = await DatabaseHelper.instance.database;

    final now = DateTime.now();

    final firstDay = DateTime(now.year, now.month, 1).toIso8601String();

    final lastDay = DateTime(
      now.year,
      now.month + 1,
      0,
      23,
      59,
      59,
    ).toIso8601String();

    final monthlyTransactions = await db.query(
      'transactions',
      where: 'transaction_date >= ? AND transaction_date <= ?',
      whereArgs: [firstDay, lastDay],
    );

    double income = 0;
    double expense = 0;

    for (final transaction in monthlyTransactions) {
      final amount = (transaction['amount'] as num).toDouble();

      if (transaction['type'] == 'income') {
        income += amount;
      } else {
        expense += amount;
      }
    }

    final balance = income - expense;

    final totalDays = DateTime(now.year, now.month + 1, 0).day;

    final remainingDays = totalDays - now.day + 1;

    final safeBudget = remainingDays > 0 && balance > 0
        ? balance / remainingDays
        : 0.0;

    final recentMaps = await db.query(
      'transactions',
      orderBy: 'transaction_date DESC',
      limit: 5,
    );

    final recentTransactions = recentMaps
        .map(TransactionModel.fromMap)
        .toList();

    return DashboardSummaryModel(
      monthlyIncome: income,
      monthlyExpense: expense,
      balance: income - expense,
      safeBudget: safeBudget,
      recentTransactions: recentTransactions,
    );
  }
}
