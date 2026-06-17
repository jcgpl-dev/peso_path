import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:peso_path/features/auth/presentation/pages/profile_page.dart';
import 'package:peso_path/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:peso_path/features/savings/presentation/bloc/savings_bloc.dart';
import 'package:peso_path/features/savings/presentation/pages/add_savings_goal_page.dart';
import 'package:peso_path/features/savings/presentation/pages/savings_page.dart';
import 'package:peso_path/features/settings/domain/use_cases/clear_all_user_data.dart';
import 'package:peso_path/features/settings/domain/use_cases/get_app_version_info.dart';
import 'package:peso_path/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:peso_path/features/settings/presentation/pages/about_us_page.dart';
import 'package:peso_path/features/settings/presentation/pages/developer_page.dart';
import 'package:peso_path/features/settings/presentation/pages/settings_page.dart';
import 'package:peso_path/features/shell/presentation/pages/shell_page.dart';
import 'package:peso_path/features/transactions/domain/entities/transaction.dart';
import 'package:peso_path/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:peso_path/features/transactions/presentation/pages/edit_transaction_page.dart';
import 'package:peso_path/features/transactions/presentation/pages/transactions_page.dart';
import 'package:peso_path/injection/injection.dart';
import '../../features/budget/presentation/pages/budget_setup_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          return const SplashPage();
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          return const RegisterPage();
        },
      ),
      GoRoute(
        path: '/budget-setup',
        builder: (_, _) => const BudgetSetupPage(),
      ),
      GoRoute(
        path: '/edit-transaction',
        builder: (context, state) {
          final extraData = state.extra as Map<String, dynamic>;
          final transactionBloc = extraData['bloc'] as TransactionBloc;
          final transaction = extraData['transaction'] as Transaction;

          return BlocProvider.value(
            value: transactionBloc,
            child: EditTransactionPage(transaction: transaction),
          );
        },
      ),
      GoRoute(
        path: '/add-savings-goal',
        builder: (context, state) {
          final savingsBloc = state.extra as SavingsBloc;
          return BlocProvider.value(
            value: savingsBloc,
            child: const AddSavingsGoalPage(),
          );
        },
      ),
      GoRoute(path: '/about', builder: (context, state) => const AboutUsPage()),
      GoRoute(
        path: '/developer',
        builder: (context, state) => const DeveloperPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (_, _) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (_, _) => const TransactionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/savings', builder: (_, _) => const SavingsPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, _) => BlocProvider(
                  create: (context) => sl<SettingsBloc>(),
                  child: const SettingsPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
