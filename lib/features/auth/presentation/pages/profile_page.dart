import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peso_path/core/theme/app_colors.dart';
import 'package:peso_path/features/auth/presentation/bloc/auth_event.dart';
import 'package:peso_path/shared/widgets/primary_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../../../../injection/injection.dart';
import '../../../../core/session/current_user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _pickAndUploadImage(BuildContext context, String userId) async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null && context.mounted) {
      context.read<AuthBloc>().add(
        UploadProfilePictureRequested(userId: userId, imagePath: image.path),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          final session = sl<CurrentUser>();
          if (!session.isLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                context.go('/login');
              }
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () {
              context.go('/dashboard');
            },
          ),
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is AuthAuthenticated) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.md),

                    GestureDetector(
                      onTap: () => _pickAndUploadImage(context, state.userId),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: colorScheme.primary.withAlpha(40),
                            backgroundImage: state.profilePicture != null
                                ? FileImage(io.File(state.profilePicture!))
                                : null,
                            child: state.profilePicture == null
                                ? Icon(
                                    Icons.person_rounded,
                                    size: 50,
                                    color: colorScheme.primary,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: colorScheme.primary,
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      state.name,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '@${state.username}',
                      style: textTheme.bodyLarge?.copyWith(
                        color: textTheme.bodySmall?.color,
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                    const Divider(),
                    const SizedBox(height: AppSpacing.md),

                    PrimaryButton(
                      text: 'Log Out',

                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Log Out'),
                            content: const Text(
                              'Are you sure you want to log out from Peso Path?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dialogContext),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext);
                                  context.read<AuthBloc>().add(
                                    LogoutRequested(),
                                  );
                                },
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(color: colorScheme.error),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }

            // Fallback UI State: if BLoC reset but session says we are logged in,
            // show a loader or trigger an event to re-fetch the user details.
            return const Center(
              child: Text('Failed to load user profile data.'),
            );
          },
        ),
      ),
    );
  }
}
