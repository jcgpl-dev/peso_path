import '../../../../core/database/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionLocalDataSource {
  final dbHelper = DatabaseHelper.instance;

  Future<void> addTransaction(TransactionModel transaction) async {
    final db = await dbHelper.database;

    await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getTransactions(String userId) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'transactions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'transaction_date DESC',
    );

    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final db = await dbHelper.database;

    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ? AND user_id = ?',
      whereArgs: [transaction.id, transaction.userId],
    );
  }

  Future<void> deleteTransaction(String id, String userId) async {
    final db = await dbHelper.database;

    await db.delete(
      'transactions',
      where: 'id = ? AND user_id = ?',
      whereArgs: [id, userId],
    );
  }
}
