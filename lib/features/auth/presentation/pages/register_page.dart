import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_spacing.dart';
import 'package:peso_path/shared/widgets/app_scaffold.dart';
import 'package:peso_path/shared/widgets/app_snackbar.dart';
import 'package:peso_path/shared/widgets/app_text_field.dart';
import 'package:peso_path/shared/widgets/primary_button.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AuthScaffold(
        title: 'Create an account',
        subtitle:
            'Join Peso Path and manage your budget with confidence and clarity.',
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthRegistered) {
              AppSnackbar.showSuccess(context, 'Account created successfully!');

              context.go('/login');
            }

            if (state is AuthFailure) {
              AppSnackbar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                AppTextField(
                  controller: nameController,
                  label: 'Fullname',
                  hintText: 'ex. Juan Dela Cruz',
                ),
                const SizedBox(height: AppSpacing.md),
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
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  text: 'Register',
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    final name = nameController.text.trim();
                    final username = usernameController.text.trim();
                    final password = passwordController.text.trim();

                    if (name.isEmpty || username.isEmpty || password.isEmpty) {
                      AppSnackbar.showError(
                        context,
                        'All fields are required.',
                      );
                      return;
                    }

                    context.read<AuthBloc>().add(
                      RegisterRequested(
                        name: name,
                        username: username,
                        password: password,
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.md),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: const Text('Login'),
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
