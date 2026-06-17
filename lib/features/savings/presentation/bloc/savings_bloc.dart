import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/usecases/add_funds_to_goal.dart';
import '../../domain/usecases/get_savings_goals.dart';
import '../../data/datasources/savings_local_datasource.dart';
import 'savings_event.dart';
import 'savings_state.dart';

class SavingsBloc extends Bloc<SavingsEvent, SavingsState> {
  final GetSavingsGoals getSavingsGoals;
  final AddFundsToGoal addFundsToGoal;
  final SavingsLocalDataSource localDataSource;

  SavingsBloc({
    required this.getSavingsGoals,
    required this.addFundsToGoal,
    required this.localDataSource,
  }) : super(SavingsInitial()) {
    on<LoadSavingsGoals>(_onLoadSavingsGoals);
    on<CreateGoalRequested>(_onCreateGoalRequested);
    on<FundGoalRequested>(_onFundGoalRequested);
  }

  Future<void> _onLoadSavingsGoals(
    LoadSavingsGoals event,
    Emitter<SavingsState> emit,
  ) async {
    emit(SavingsLoading());
    try {
      final goals = await getSavingsGoals();
      emit(SavingsLoaded(goals));
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }

  Future<void> _onCreateGoalRequested(
    CreateGoalRequested event,
    Emitter<SavingsState> emit,
  ) async {
    try {
      final newGoal = SavingsGoal(
        id: const Uuid().v4(),
        userId: '',
        title: event.title,
        targetAmount: event.targetAmount,
        currentAmount: 0.0,
        createdAt: DateTime.now().toIso8601String(),
      );
      await localDataSource.createSavingsGoal(newGoal);
      emit(SavingsOperationSuccess());
      add(LoadSavingsGoals());
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }

  Future<void> _onFundGoalRequested(
    FundGoalRequested event,
    Emitter<SavingsState> emit,
  ) async {
    try {
      await addFundsToGoal(event.goalId, event.amount);
      emit(SavingsOperationSuccess());
      add(LoadSavingsGoals());
    } catch (e) {
      emit(SavingsError(e.toString()));
    }
  }
}
