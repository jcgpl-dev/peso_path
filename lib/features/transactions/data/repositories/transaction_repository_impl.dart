import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource datasource;

  TransactionRepositoryImpl(this.datasource);

  @override
  Future<void> addTransaction(Transaction transaction) {
    return datasource.addTransaction(
      TransactionModel(
        id: transaction.id,
        title: transaction.title,
        amount: transaction.amount,
        type: transaction.type,
        category: transaction.category,
        note: transaction.note,
        transactionDate: transaction.transactionDate,
        createdAt: transaction.createdAt,
      ),
    );
  }

  @override
  Future<List<Transaction>> getTransactions() {
    return datasource.getTransactions();
  }

  @override
  Future<void> deleteTransaction(String id) {
    return datasource.deleteTransaction(id);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) {
    return datasource.updateTransaction(
      TransactionModel(
        id: transaction.id,
        title: transaction.title,
        amount: transaction.amount,
        type: transaction.type,
        category: transaction.category,
        note: transaction.note,
        transactionDate: transaction.transactionDate,
        createdAt: transaction.createdAt,
      ),
    );
  }
}
