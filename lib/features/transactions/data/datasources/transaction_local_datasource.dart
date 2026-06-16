import '../../../../core/database/database_helper.dart';
import '../models/transaction_model.dart';

class TransactionLocalDataSource {
  final dbHelper = DatabaseHelper.instance;

  Future<void> addTransaction(TransactionModel transaction) async {
    final db = await dbHelper.database;

    await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getTransactions() async {
    final db = await dbHelper.database;

    final result = await db.query(
      'transactions',
      orderBy: 'transaction_date DESC',
    );

    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    final db = await dbHelper.database;

    await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(String id) async {
    final db = await dbHelper.database;

    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }
}
