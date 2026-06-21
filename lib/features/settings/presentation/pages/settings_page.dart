import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:peso_path/core/theme/app_colors.dart';
import 'package:peso_path/core/theme/app_spacing.dart';
import 'package:peso_path/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:peso_path/features/auth/presentation/bloc/auth_event.dart';
import 'package:peso_path/features/auth/presentation/bloc/auth_state.dart';
import 'package:peso_path/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:peso_path/features/settings/presentation/bloc/settings_event.dart';
import 'package:peso_path/features/settings/presentation/bloc/settings_state.dart';
import 'package:peso_path/features/settings/presentation/bloc/theme_cubit.dart';
import 'package:peso_path/features/settings/presentation/widgets/settings_tile.dart';
import 'package:peso_path/shared/widgets/app_confirmation_dialog.dart';
import 'package:peso_path/shared/widgets/app_snackbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(LoadSettingsInfoRequested());
    context.read<AuthBloc>().add(LoadAllAccountsRequested());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is DataWipeSuccess) {
          AppSnackbar.showSuccess(context, 'All local device records cleared!');
          context.read<AuthBloc>().add(LogoutRequested());
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          children: [
            const SizedBox(height: AppSpacing.md),

            _buildSectionHeader('Account'),

            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                if (authState is AuthAuthenticated) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SettingsTile(
                        icon: Icons.person_outline,
                        title: 'Profile Details',
                        subtitle:
                            'Logged in as: ${authState.name} (@${authState.username})',
                        onTap: () => context.push('/profile'),
                      ),
                      SettingsTile(
                        icon: Icons.switch_account_outlined,
                        title: 'Switch Profile',
                        subtitle: 'Swap active local storage namespace',
                        onTap: () =>
                            _showAccountSwitchBottomSheet(context, authState),
                      ),
                    ],
                  );
                }
                return SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Profile Details',
                  subtitle: 'Update your display profile',
                  onTap: () => context.push('/profile'),
                );
              },
            ),

            SettingsTile(
              icon: Icons.logout,
              title: 'Sign Out',
              subtitle: 'Log out of your account securely',
              iconColor: AppColors.expense,
              onTap: () => _showSignOutDialog(context),
            ),

            const SizedBox(height: AppSpacing.lg),
            _buildSectionHeader('Preferences'),
            SettingsTile(
              icon: isDark ? Icons.dark_mode : Icons.light_mode,
              title: 'Theme Mode',
              subtitle: isDark ? 'Dark Mode Active' : 'Light Mode Active',
              trailing: Switch(
                value: isDark,
                onChanged: (bool value) {
                  context.read<ThemeCubit>().toggleTheme(value);
                },
                trackOutlineColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
                trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary.withValues(alpha: 0.16);
                  }
                  return isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.06);
                }),
                thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary;
                  }
                  return isDark ? Colors.grey[400] : Colors.grey[500];
                }),
              ),
            ),
            SettingsTile(
              icon: Icons.refresh_rounded,
              title: 'Manage Budget Cycles',
              subtitle: 'Setup or reset budget milestones',
              onTap: () => context.push('/budget-setup'),
            ),

            const SizedBox(height: AppSpacing.lg),
            _buildSectionHeader('App Info'),
            SettingsTile(
              icon: Icons.info_outline_rounded,
              title: 'About Peso Path',
              subtitle: 'Learn more about our finance mission',
              onTap: () => context.push('/about'),
            ),
            SettingsTile(
              icon: Icons.code_rounded,
              title: 'Developer Details',
              subtitle: 'Meet the developer behind the app',
              onTap: () => context.push('/developer'),
            ),

            const SizedBox(height: AppSpacing.lg),
            _buildSectionHeader('Data Management'),
            SettingsTile(
              icon: Icons.delete_forever_outlined,
              title: 'Reset All Data',
              subtitle: 'Wipe all records permanently',
              iconColor: AppColors.expense,
              onTap: () => _showResetDataDialog(context),
            ),

            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.xs,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: AppColors.primary,
        ),
      ),
    );
  }

  void _showAccountSwitchBottomSheet(
    BuildContext context,
    AuthAuthenticated state,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Switch Profile',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppSpacing.md),
                if (state.availableAccounts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    child: Text(
                      'No alternative local profiles found.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ),
                ...state.availableAccounts.map((account) {
                  final isActive = account.id == state.userId;

                  // 2. Safely check if the account object has a valid profile picture path string.
                  // (Using try/catch-esque dynamic properties check or direct property depending on model implementation)
                  final hasProfilePic =
                      account.profilePicture != null &&
                      account.profilePicture!.isNotEmpty;

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      backgroundImage: hasProfilePic
                          ? FileImage(io.File(account.profilePicture!))
                          : null,
                      child: !hasProfilePic
                          ? Text(
                              account.name.isNotEmpty
                                  ? account.name.substring(0, 1).toUpperCase()
                                  : 'U',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    title: Text(
                      account.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text('@${account.username}'),
                    trailing: isActive
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: isActive
                        ? null
                        : () {
                            Navigator.pop(modalContext);
                            context.read<AuthBloc>().add(
                              SwitchAccountRequested(account.id),
                            );
                            AppSnackbar.showSuccess(
                              context,
                              'Switched to profile: ${account.name}',
                            );
                          },
                  );
                }),
                const Divider(height: AppSpacing.lg),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    child: const Icon(Icons.add, color: Colors.grey),
                  ),
                  title: const Text(
                    'Create New Local Profile',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    Navigator.pop(modalContext);
                    context.push('/register');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (innerContext) => AppConfirmationDialog(
        title: 'Sign Out',
        message: 'Are you sure you want to log out from Peso Path?',
        confirmText: 'Sign Out',
        isDestructive: true,
        onConfirm: () {
          context.read<AuthBloc>().add(LogoutRequested());
          context.go('/login');
        },
      ),
    );
  }

  void _showResetDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (innerContext) => AppConfirmationDialog(
        title: 'Reset All Data',
        message:
            'This will delete all data permanently. This cannot be undone.',
        confirmText: 'Wipe Everything',
        isDestructive: true,
        onConfirm: () {
          Navigator.pop(innerContext);
          context.read<SettingsBloc>().add(WipeAllUserDataRequested());
        },
      ),
    );
  }
}
