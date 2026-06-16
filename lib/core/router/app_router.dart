import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/features/auth/presentation/pages/profile_page.dart';
import 'package:peso_path/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:peso_path/features/savings/presentation/pages/savings_page.dart';
import 'package:peso_path/features/settings/presentation/pages/settings_page.dart';
import 'package:peso_path/features/shell/presentation/pages/shell_page.dart';
import 'package:peso_path/features/transactions/domain/entities/transaction.dart';
import 'package:peso_path/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:peso_path/features/transactions/presentation/pages/edit_transaction_page.dart';
import 'package:peso_path/features/transactions/presentation/pages/transactions_page.dart';
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
                builder: (_, _) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
