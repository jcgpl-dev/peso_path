import 'package:peso_path/features/budget/data/datasources/budget_local_datasource.dart';
import 'package:peso_path/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:peso_path/features/budget/domain/repositories/budget_repository.dart';
import 'package:peso_path/features/budget/domain/usecases/create_budget_cycle.dart';
import 'package:peso_path/features/budget/domain/usecases/get_active_budget_cycle.dart';
import 'package:peso_path/features/budget/domain/usecases/update_budget_cycle.dart';
import 'package:peso_path/features/budget/presentation/bloc/budget_bloc.dart';

import '../core/session/current_user.dart';
import 'package:get_it/get_it.dart';
import 'package:peso_path/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:peso_path/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:peso_path/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:peso_path/features/transactions/domain/usecases/add_transaction.dart';
import 'package:peso_path/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:peso_path/features/transactions/domain/usecases/get_transactions.dart';
import 'package:peso_path/features/transactions/domain/usecases/update_transaction.dart';
import 'package:peso_path/features/transactions/presentation/bloc/transaction_bloc.dart';

import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_user.dart';
import '../features/auth/domain/usecases/register_user.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

import 'package:peso_path/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:peso_path/features/dashboard/data/repositories/dashboard_repository_impl.dart';

import 'package:peso_path/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:peso_path/features/dashboard/domain/usecases/get_dashboard_summary.dart';

import 'package:peso_path/features/dashboard/presentation/bloc/dashboard_bloc.dart';

import 'package:peso_path/core/session/current_user.dart';

import 'package:peso_path/features/budget/data/datasources/budget_local_datasource.dart';
import 'package:peso_path/features/budget/data/repositories/budget_repository_impl.dart';

import 'package:peso_path/features/budget/domain/repositories/budget_repository.dart';

import 'package:peso_path/features/budget/domain/usecases/create_budget_cycle.dart';
import 'package:peso_path/features/budget/domain/usecases/get_active_budget_cycle.dart';
import 'package:peso_path/features/budget/domain/usecases/update_budget_cycle.dart';

import 'package:peso_path/features/budget/presentation/bloc/budget_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<CurrentUser>(() => CurrentUser());

  // Datasource

  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource());

  // Repository

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthLocalDataSource>()),
  );

  // Use Cases

  sl.registerLazySingleton(() => RegisterUser(sl<AuthRepository>()));

  sl.registerLazySingleton(() => LoginUser(sl<AuthRepository>()));

  // Bloc

  sl.registerFactory(
    () => AuthBloc(
      registerUser: sl<RegisterUser>(),
      loginUser: sl<LoginUser>(),
      currentUser: sl<CurrentUser>(),
    ),
  );
  // Datasource
  sl.registerLazySingleton(() => TransactionLocalDataSource());

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl(), sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => AddTransaction(sl()));

  sl.registerLazySingleton(() => GetTransactions(sl()));

  sl.registerLazySingleton(() => DeleteTransaction(sl()));

  sl.registerLazySingleton(() => UpdateTransaction(sl()));

  // Bloc
  sl.registerFactory(
    () => TransactionBloc(
      addTransaction: sl(),
      getTransactions: sl(),
      updateTransaction: sl(),
      deleteTransaction: sl(),
    ),
  );

  // Dashboard Datasource

  sl.registerLazySingleton(() => DashboardLocalDataSource(sl()));

  // Dashboard Repository

  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );

  // Dashboard UseCase

  sl.registerLazySingleton(() => GetDashboardSummary(sl()));

  // Dashboard Bloc

  sl.registerFactory(() => DashboardBloc(getDashboardSummary: sl()));

  // Budget Datasource

  sl.registerLazySingleton(() => BudgetLocalDataSource(sl<CurrentUser>()));

  // Repository

  sl.registerLazySingleton<BudgetRepository>(() => BudgetRepositoryImpl(sl()));

  // UseCases

  sl.registerLazySingleton(() => CreateBudgetCycle(sl()));

  sl.registerLazySingleton(() => UpdateBudgetCycle(sl()));

  sl.registerLazySingleton(() => GetActiveBudgetCycle(sl()));

  // Bloc

  sl.registerFactory(
    () => BudgetBloc(
      createBudgetCycle: sl(),
      getActiveBudgetCycle: sl(),
      currentUser: sl(),
    ),
  );
}
