import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peso_path/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:peso_path/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:peso_path/features/savings/presentation/bloc/savings_bloc.dart';
import 'package:peso_path/features/savings/presentation/bloc/savings_event.dart';
import 'package:peso_path/features/savings/presentation/bloc/savings_state.dart';
import 'package:peso_path/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:peso_path/features/transactions/presentation/bloc/transaction_event.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'injection/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SavingsBloc>(
          create: (context) => sl<SavingsBloc>()..add(LoadSavingsGoals()),
        ),

        BlocListener<SavingsBloc, SavingsState>(
          listener: (context, state) {
            if (state is SavingsOperationSuccess) {
              context.read<TransactionBloc>().add(LoadTransactions());
            }
          },
        ),
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),

        BlocProvider<DashboardBloc>(create: (_) => sl<DashboardBloc>()),

        BlocProvider<BudgetBloc>(create: (_) => sl<BudgetBloc>()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Peso Path',

        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        routerConfig: AppRouter.router,
      ),
    );
  }
}
