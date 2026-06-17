import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_spacing.dart';
import 'package:peso_path/features/budget/presentation/bloc/budget_bloc.dart';
import 'package:peso_path/shared/widgets/app_scaffold.dart';
import 'package:peso_path/shared/widgets/app_snackbar.dart';
import 'package:peso_path/shared/widgets/app_text_field.dart';
import 'package:peso_path/shared/widgets/primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _keepLoggedIn = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AuthScaffold(
        title: 'Welcome back',
        subtitle:
            'Log in to your account and manage your budget with confidence and clarity.!',
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthAuthenticated) {
              if (!context.mounted) return;

              AppSnackbar.showSuccess(context, 'Welcome ${state.username}');

              final hasBudget = await context
                  .read<BudgetBloc>()
                  .hasActiveBudgetCycle();

              if (!context.mounted) return;

              if (hasBudget) {
                context.go('/dashboard');
              } else {
                context.go('/budget-setup');
              }
            }

            if (state is AuthFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                AppTextField(
                  controller: usernameController,
                  label: 'Username',
                  hintText: 'ex. juan...',
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: passwordController,
                  label: 'Password',
                  isPassword: true,
                ),
                const SizedBox(height: AppSpacing.md),
                CheckboxListTile(
                  title: const Text("Keep me logged in"),
                  value: _keepLoggedIn,

                  onChanged: (value) =>
                      setState(() => _keepLoggedIn = value ?? false),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  text: 'Login',
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      LoginRequested(
                        username: usernameController.text.trim(),
                        password: passwordController.text.trim(),
                        keepLoggedIn: _keepLoggedIn,
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        context.go('/register');
                      },
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
