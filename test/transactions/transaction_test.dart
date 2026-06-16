import 'package:flutter_test/flutter_test.dart';
import 'package:peso_path/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:peso_path/features/transactions/data/models/transaction_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Transaction Feature', () {
    test('add and retrieve transaction', () async {
      final datasource = TransactionLocalDataSource();

      final transaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: '2132132312',
        title: 'Lunch',
        amount: 150.0,
        type: 'expense',
        category: 'Food',
        note: 'Chicken meal',
        transactionDate: DateTime.now().toIso8601String(),
        createdAt: DateTime.now().toIso8601String(),
      );

      await datasource.addTransaction(transaction);

      final transactions = await datasource.getTransactions('2324233');

      expect(transactions.isNotEmpty, true);

      expect(transactions.first.title, 'Lunch');

      expect(transactions.first.amount, 150.0);
    });
  });
}
