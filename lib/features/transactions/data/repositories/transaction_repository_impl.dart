import '../../../../core/session/current_user.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_local_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource datasource;
  final CurrentUser currentUser;

  TransactionRepositoryImpl(this.datasource, this.currentUser);

  String get _userId => currentUser.requireUserId();

  TransactionModel _toModel(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      userId: transaction.userId,
      title: transaction.title,
      amount: transaction.amount,
      type: transaction.type,
      category: transaction.category,
      note: transaction.note,
      transactionDate: transaction.transactionDate,
      createdAt: transaction.createdAt,
    );
  }

  @override
  Future<void> addTransaction(Transaction transaction) {
    return datasource.addTransaction(
      _toModel(transaction.copyWith(userId: _userId)),
    );
  }

  @override
  Future<List<Transaction>> getTransactions() {
    return datasource.getTransactions(_userId);
  }

  @override
  Future<void> deleteTransaction(String id) {
    return datasource.deleteTransaction(id, _userId);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) {
    return datasource.updateTransaction(_toModel(transaction));
  }
}

extension on Transaction {
  Transaction copyWith({String? userId}) {
    return Transaction(
      id: id,
      userId: userId ?? this.userId,
      title: title,
      amount: amount,
      type: type,
      category: category,
      note: note,
      transactionDate: transactionDate,
      createdAt: createdAt,
    );
  }
}
