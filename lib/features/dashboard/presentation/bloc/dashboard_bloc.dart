import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_dashboard_summary.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({required GetDashboardSummary getDashboardSummary})
    : _getDashboardSummary = getDashboardSummary,
      super(DashboardInitial()) {
    on<LoadDashboardSummary>(_onLoadDashboardSummary);
  }

  final GetDashboardSummary _getDashboardSummary;

  Future<void> _onLoadDashboardSummary(
    LoadDashboardSummary event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      final summary = await _getDashboardSummary();

      emit(DashboardLoaded(summary));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
