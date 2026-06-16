import '../../../../core/database/database_helper.dart';
import '../../../../core/session/current_user.dart';

import '../models/budget_cycle_model.dart';

class BudgetLocalDataSource {
  final CurrentUser currentUser;

  BudgetLocalDataSource(this.currentUser);

  Future<void> createBudgetCycle(BudgetCycleModel cycle) async {
    final db = await DatabaseHelper.instance.database;

    await db.update(
      'budget_cycles',
      {'is_active': 0},
      where: 'user_id = ?',
      whereArgs: [cycle.userId],
    );

    await db.insert('budget_cycles', cycle.toMap());
  }

  Future<void> updateBudgetCycle(BudgetCycleModel cycle) async {
    final db = await DatabaseHelper.instance.database;

    await db.update(
      'budget_cycles',
      cycle.toMap(),
      where: 'id = ?',
      whereArgs: [cycle.id],
    );
  }

  Future<BudgetCycleModel?> getActiveBudgetCycle() async {
    final db = await DatabaseHelper.instance.database;

    final userId = currentUser.requireUserId();

    final result = await db.query(
      'budget_cycles',
      where: 'user_id = ? AND is_active = 1',
      whereArgs: [userId],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return BudgetCycleModel.fromMap(result.first);
  }
}
