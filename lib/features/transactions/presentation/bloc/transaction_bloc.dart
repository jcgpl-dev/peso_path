import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/update_transaction.dart';

import 'transaction_event.dart';
import 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final AddTransaction addTransaction;
  final GetTransactions getTransactions;
  final UpdateTransaction updateTransaction;
  final DeleteTransaction deleteTransaction;

  TransactionBloc({
    required this.addTransaction,
    required this.getTransactions,
    required this.updateTransaction,
    required this.deleteTransaction,
  }) : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);

    on<AddTransactionRequested>(_onAddTransaction);

    on<UpdateTransactionRequested>(_onUpdateTransaction);

    on<DeleteTransactionRequested>(_onDeleteTransaction);
  }

  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    await _loadTransactions(emit);
  }

  Future<void> _onAddTransaction(
    AddTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    try {
      await addTransaction(event.transaction);

      emit(TransactionAdded());

      await _loadTransactions(emit, showLoading: false);
    } catch (e) {
      emit(TransactionFailure(e.toString()));
    }
  }

  Future<void> _onUpdateTransaction(
    UpdateTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    try {
      await updateTransaction(event.transaction);

      emit(TransactionUpdated());

      await _loadTransactions(emit, showLoading: false);
    } catch (e) {
      emit(TransactionFailure(e.toString()));
    }
  }

  Future<void> _onDeleteTransaction(
    DeleteTransactionRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());

    try {
      await deleteTransaction(event.id);

      emit(TransactionDeleted());

      await _loadTransactions(emit, showLoading: false);
    } catch (e) {
      emit(TransactionFailure(e.toString()));
    }
  }

  Future<void> _loadTransactions(
    Emitter<TransactionState> emit, {
    bool showLoading = true,
  }) async {
    if (showLoading) {
      emit(TransactionLoading());
    }

    try {
      final transactions = await getTransactions();

      emit(TransactionLoaded(transactions));
    } catch (e) {
      emit(TransactionFailure(e.toString()));
    }
  }
}
