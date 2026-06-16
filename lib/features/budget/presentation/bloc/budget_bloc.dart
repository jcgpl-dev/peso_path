import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peso_path/features/budget/domain/usecases/update_budget_cycle.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/session/current_user.dart';

import '../../domain/entities/budget_cycle.dart';

import '../../domain/usecases/create_budget_cycle.dart';
import '../../domain/usecases/get_active_budget_cycle.dart';

import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final CreateBudgetCycle createBudgetCycle;
  final UpdateBudgetCycle updateBudgetCycle;
  final GetActiveBudgetCycle getActiveBudgetCycle;

  final CurrentUser currentUser;

  BudgetBloc({
    required this.createBudgetCycle,
    required this.updateBudgetCycle,
    required this.getActiveBudgetCycle,
    required this.currentUser,
  }) : super(BudgetInitial()) {
    on<LoadActiveBudgetCycle>(_onLoadActiveBudgetCycle);
    on<UpdateBudgetCycleRequested>(_onUpdateBudgetCycleRequested);
    on<CreateBudgetCycleRequested>(_onCreateBudgetCycleRequested);
  }

  Future<void> _onUpdateBudgetCycleRequested(
    UpdateBudgetCycleRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());

    try {
      final current = await getActiveBudgetCycle();

      if (current == null) {
        emit(const BudgetError('No active budget found'));
        return;
      }

      await updateBudgetCycle(
        BudgetCycle(
          id: event.id,
          userId: current.userId,
          budgetAmount: event.budgetAmount,
          startDate: event.startDate.toIso8601String(),
          endDate: event.endDate.toIso8601String(),
          isActive: true,
          createdAt: current.createdAt,
        ),
      );

      emit(BudgetCreated());

      add(LoadActiveBudgetCycle());
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<void> _onLoadActiveBudgetCycle(
    LoadActiveBudgetCycle event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());

    try {
      final cycle = await getActiveBudgetCycle();

      if (cycle == null) {
        emit(const BudgetError('No active budget cycle'));
        return;
      }

      emit(BudgetLoaded(cycle));
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }

  Future<bool> hasActiveBudgetCycle() async {
    final cycle = await getActiveBudgetCycle();

    return cycle != null;
  }

  Future<void> _onCreateBudgetCycleRequested(
    CreateBudgetCycleRequested event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());

    try {
      final cycle = BudgetCycle(
        id: const Uuid().v4(),
        userId: currentUser.requireUserId(),
        budgetAmount: event.budgetAmount,
        startDate: event.startDate.toIso8601String(),
        endDate: event.endDate.toIso8601String(),
        isActive: true,
        createdAt: DateTime.now().toIso8601String(),
      );

      await createBudgetCycle(cycle);

      emit(BudgetCreated());

      add(LoadActiveBudgetCycle());
    } catch (e) {
      emit(BudgetError(e.toString()));
    }
  }
}
