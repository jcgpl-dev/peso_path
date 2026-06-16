import 'package:equatable/equatable.dart';

import '../../domain/entities/transaction.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class AddTransactionRequested extends TransactionEvent {
  final Transaction transaction;

  const AddTransactionRequested(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class UpdateTransactionRequested extends TransactionEvent {
  final Transaction transaction;

  const UpdateTransactionRequested(this.transaction);

  @override
  List<Object?> get props => [transaction];
}

class DeleteTransactionRequested extends TransactionEvent {
  final String id;

  const DeleteTransactionRequested(this.id);

  @override
  List<Object?> get props => [id];
}
