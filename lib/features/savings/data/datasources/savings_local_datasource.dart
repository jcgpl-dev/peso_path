import 'package:peso_path/core/database/database_helper.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/session/current_user.dart';
import '../../domain/entities/savings_goal.dart';

class SavingsLocalDataSource {
  final CurrentUser currentUser;

  SavingsLocalDataSource(this.currentUser);

  Future<List<SavingsGoal>> getSavingsGoals() async {
    final db = await DatabaseHelper.instance.database;
    final userId = currentUser.requireUserId();

    final maps = await db.query(
      'savings_goals',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );

    return maps.map((map) {
      return SavingsGoal(
        id: map['id'] as String,
        userId: map['user_id'] as String,
        title: map['title'] as String,
        targetAmount: (map['target_amount'] as num).toDouble(),
        currentAmount: (map['current_amount'] as num).toDouble(),
        createdAt: map['created_at'] as String,
      );
    }).toList();
  }

  Future<void> createSavingsGoal(SavingsGoal goal) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert('savings_goals', {
      'id': goal.id,
      'user_id': currentUser.requireUserId(),
      'title': goal.title,
      'target_amount': goal.targetAmount,
      'current_amount': goal.currentAmount,
      'created_at': goal.createdAt,
    });
  }

  Future<void> addFundsToGoal(String goalId, double amount) async {
    final db = await DatabaseHelper.instance.database;
    final userId = currentUser.requireUserId();

    await db.transaction((txn) async {
      await txn.rawUpdate(
        '''
        UPDATE savings_goals 
        SET current_amount = current_amount + ? 
        WHERE id = ? AND user_id = ?
      ''',
        [amount, goalId, userId],
      );

      final goalResult = await txn.query(
        'savings_goals',
        columns: ['title'],
        where: 'id = ?',
        whereArgs: [goalId],
        limit: 1,
      );
      final goalTitle = goalResult.first['title'] as String;

      await txn.insert('transactions', {
        'id': const Uuid().v4(),
        'user_id': userId,
        'title': 'Funded: $goalTitle',
        'amount': amount,
        'type': 'expense',
        'category': 'Savings',
        'note': 'Transferred to savings pool goals',
        'transaction_date': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
    });
  }

  Future<void> subtractFundsFromGoal(
    String transactionTitle,
    double amount,
  ) async {
    final db = await DatabaseHelper.instance.database;
    final userId = currentUser.requireUserId();

    final goalName = transactionTitle.replaceFirst('Funded: ', '');

    await db.transaction((txn) async {
      await txn.rawUpdate(
        '''
      UPDATE savings_goals 
      SET current_amount = current_amount - ? 
      WHERE title = ? AND user_id = ?
      ''',
        [amount, goalName, userId],
      );
    });
  }
}
