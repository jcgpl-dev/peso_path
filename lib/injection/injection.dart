import 'package:get_it/get_it.dart';
import 'package:peso_path/core/database/database_helper.dart';
import 'package:peso_path/features/settings/data/datasources/settings_local_datasource.dart';
import 'package:peso_path/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:peso_path/features/settings/domain/repositories/settings_repository.dart';
import 'package:peso_path/features/settings/domain/use_cases/clear_all_user_data.dart';
import 'package:peso_path/features/settings/domain/use_cases/get_app_version_info.dart';
import 'package:peso_path/features/settings/domain/use_cases/manage_theme.dart';
import 'package:peso_path/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:peso_path/features/settings/presentation/bloc/theme_cubit.dart';

import '../core/session/current_user.dart';

// Auth
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_user.dart';
import '../features/auth/domain/usecases/logout_user.dart';
import '../features/auth/domain/usecases/register_user.dart';
import '../features/auth/domain/usecases/update_profile_pic.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/domain/usecases/switch_account.dart';
import '../features/auth/domain/usecases/get_all_accounts.dart';

// Budget
import 'package:peso_path/features/budget/data/datasources/budget_local_datasource.dart';
import 'package:peso_path/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:peso_path/features/budget/domain/repositories/budget_repository.dart';
import 'package:peso_path/features/budget/domain/usecases/create_budget_cycle.dart';
import 'package:peso_path/features/budget/domain/usecases/get_active_budget_cycle.dart';
import 'package:peso_path/features/budget/domain/usecases/update_budget_cycle.dart';
import 'package:peso_path/features/budget/presentation/bloc/budget_bloc.dart';

// Dashboard
import 'package:peso_path/features/dashboard/data/datasources/dashboard_local_datasource.dart';
import 'package:peso_path/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:peso_path/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:peso_path/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:peso_path/features/dashboard/presentation/bloc/dashboard_bloc.dart';

// Savings (New Features Added)
import 'package:peso_path/features/savings/data/datasources/savings_local_datasource.dart';
import 'package:peso_path/features/savings/data/repositories/savings_repository_impl.dart';
import 'package:peso_path/features/savings/domain/repositories/savings_repository.dart';
import 'package:peso_path/features/savings/domain/usecases/add_funds_to_goal.dart';
import 'package:peso_path/features/savings/domain/usecases/get_savings_goals.dart';
import 'package:peso_path/features/savings/presentation/bloc/savings_bloc.dart';

// Transactions
import 'package:peso_path/features/transactions/data/datasources/transaction_local_datasource.dart';
import 'package:peso_path/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:peso_path/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:peso_path/features/transactions/domain/usecases/add_transaction.dart';
import 'package:peso_path/features/transactions/domain/usecases/delete_transaction.dart';
import 'package:peso_path/features/transactions/domain/usecases/get_transactions.dart';
import 'package:peso_path/features/transactions/domain/usecases/update_transaction.dart';
import 'package:peso_path/features/transactions/presentation/bloc/transaction_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Session tracking core initialization
  sl.registerLazySingleton<CurrentUser>(() => CurrentUser());

  // Auth Datasource
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource());

  // Auth Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthLocalDataSource>()),
  );

  // Auth Use Cases
  sl.registerLazySingleton(() => RegisterUser(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LoginUser(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUser(sl<AuthRepository>()));
  sl.registerLazySingleton(() => UpdateProfilePic(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SwitchAccount(sl<AuthRepository>()));
  sl.registerLazySingleton(() => GetAllAccounts(sl<AuthRepository>()));

  // Auth Bloc
  sl.registerFactory(
    () => AuthBloc(
      registerUser: sl<RegisterUser>(),
      loginUser: sl<LoginUser>(),
      logoutUser: sl<LogoutUser>(),
      updateProfilePic: sl<UpdateProfilePic>(),
      currentUser: sl<CurrentUser>(),
      authLocalDataSource: sl<AuthLocalDataSource>(),
      switchAccount: sl<SwitchAccount>(),
      getAllAccounts: sl<GetAllAccounts>(),
    ),
  );

  // Transaction Datasource
  sl.registerLazySingleton(() => TransactionLocalDataSource());

  // Transaction Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(sl(), sl()),
  );

  // Transaction UseCases
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));

  // Transaction Bloc
  sl.registerFactory(
    () => TransactionBloc(
      addTransaction: sl(),
      getTransactions: sl(),
      updateTransaction: sl(),
      deleteTransaction: sl(),
      savingsDataSource: sl<SavingsLocalDataSource>(),
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

  // Budget Repository
  sl.registerLazySingleton<BudgetRepository>(() => BudgetRepositoryImpl(sl()));

  // Budget UseCases
  sl.registerLazySingleton(() => CreateBudgetCycle(sl()));
  sl.registerLazySingleton(() => UpdateBudgetCycle(sl()));
  sl.registerLazySingleton(() => GetActiveBudgetCycle(sl()));

  // Budget Bloc
  sl.registerFactory(
    () => BudgetBloc(
      createBudgetCycle: sl(),
      updateBudgetCycle: sl(),
      getActiveBudgetCycle: sl(),
      currentUser: sl(),
    ),
  );

  // Savings Datasource (passes the core tracking CurrentUser)
  sl.registerLazySingleton(() => SavingsLocalDataSource(sl<CurrentUser>()));

  // Savings Repository
  sl.registerLazySingleton<SavingsRepository>(
    () => SavingsRepositoryImpl(sl<SavingsLocalDataSource>()),
  );

  // Savings Use Cases
  sl.registerLazySingleton(() => GetSavingsGoals(sl<SavingsRepository>()));
  sl.registerLazySingleton(() => AddFundsToGoal(sl<SavingsRepository>()));

  // Savings Bloc
  sl.registerFactory(
    () => SavingsBloc(
      getSavingsGoals: sl<GetSavingsGoals>(),
      addFundsToGoal: sl<AddFundsToGoal>(),
      localDataSource: sl<SavingsLocalDataSource>(),
    ),
  );

  // Settings Datasource
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSourceImpl(DatabaseHelper.instance),
  );

  // Settings Repository
  sl.registerLazySingleton<SettingsRepository>(
    () =>
        SettingsRepositoryImpl(localDataSource: sl<SettingsLocalDataSource>()),
  );

  // Settings Use Cases
  sl.registerLazySingleton(() => GetAppVersionInfo(sl<SettingsRepository>()));
  sl.registerLazySingleton(() => ClearAllUserData(sl<SettingsRepository>()));

  sl.registerFactory(
    () => SettingsBloc(
      getAppVersionInfo: sl<GetAppVersionInfo>(),
      clearAllUserData: sl<ClearAllUserData>(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoadThemePreference(sl()));
  sl.registerLazySingleton(() => SaveThemePreference(sl()));

  // Cubit
  sl.registerFactory(
    () => ThemeCubit(loadThemePreference: sl(), saveThemePreference: sl()),
  );
}
