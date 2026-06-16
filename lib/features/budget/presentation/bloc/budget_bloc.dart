import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/create_budget_cycle.dart';
import '../../domain/usecases/get_active_budget_cycle.dart';
import '../../domain/usecases/update_budget_cycle.dart';

import 'budget_event.dart';
import 'budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  final CreateBudgetCycle createBudgetCycle;

  final UpdateBudgetCycle updateBudgetCycle;

  final GetActiveBudgetCycle getActiveBudgetCycle;

  BudgetBloc({
    required this.createBudgetCycle,
    required this.updateBudgetCycle,
    required this.getActiveBudgetCycle,
  }) : super(BudgetInitial()) {
    on<LoadActiveBudget>(_onLoadActiveBudget);

    on<CreateBudgetRequested>(_onCreateBudget);

    on<UpdateBudgetRequested>(_onUpdateBudget);
  }

  Future<void> _onLoadActiveBudget(
    LoadActiveBudget event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());

    try {
      final cycle = await getActiveBudgetCycle();

      emit(BudgetLoaded(cycle));
    } catch (e) {
      emit(BudgetFailure(e.toString()));
    }
  }

  Future<void> _onCreateBudget(
    CreateBudgetRequested event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await createBudgetCycle(event.cycle);

      emit(BudgetCreated());

      add(LoadActiveBudget());
    } catch (e) {
      emit(BudgetFailure(e.toString()));
    }
  }

  Future<void> _onUpdateBudget(
    UpdateBudgetRequested event,
    Emitter<BudgetState> emit,
  ) async {
    try {
      await updateBudgetCycle(event.cycle);

      emit(BudgetUpdated());

      add(LoadActiveBudget());
    } catch (e) {
      emit(BudgetFailure(e.toString()));
    }
  }
}
