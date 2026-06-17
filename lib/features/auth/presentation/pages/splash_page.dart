import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_colors.dart';
import 'package:peso_path/core/theme/app_spacing.dart';
import 'package:peso_path/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:peso_path/features/auth/presentation/bloc/auth_event.dart';
import 'package:peso_path/features/auth/presentation/bloc/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _timerDone = false;
  AuthState? _pendingState;

  @override
  void initState() {
    super.initState();
    _startMinimumTimer();

    context.read<AuthBloc>().add(RestoreSessionRequested());
  }

  Future<void> _startMinimumTimer() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _timerDone = true;
    });

    if (_pendingState != null) {
      _handleNavigation(_pendingState!);
    }
  }

  void _handleNavigation(AuthState state) {
    if (state is AuthAuthenticated) {
      context.go('/dashboard');
    } else if (state is AuthInitial || state is AuthFailure) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) return;

        if (_timerDone) {
          _handleNavigation(state);
        } else {
          _pendingState = state;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'lib/assets/icons/ic-peso-path.png',
                width: 80,
                height: 80,
              ),
              SizedBox(height: AppSpacing.md),
              const Text(
                'Peso Path',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Outfit',
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const Spacer(),
              const Text(
                'Developed by',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.darkTextPrimary,
                ),
              ),
              const Text(
                'Jesie Gapol',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Outfit',
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkTextPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.md),
            ],
          ),
        ),
      ),
    );
  }
}
