import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:peso_path/core/theme/app_radius.dart';
import 'package:peso_path/features/auth/presentation/bloc/auth_event.dart';
import 'package:peso_path/shared/widgets/app_confirmation_dialog.dart';
import 'package:peso_path/shared/widgets/app_snackbar.dart';
import 'package:peso_path/shared/widgets/primary_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../../../../injection/injection.dart';
import '../../../../core/session/current_user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ValueNotifier<bool> _isUploadingNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _isUploadingNotifier.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage(BuildContext context, String userId) async {
    final picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null && context.mounted) {
        _isUploadingNotifier.value = true;
        context.read<AuthBloc>().add(
          UploadProfilePictureRequested(userId: userId, imagePath: image.path),
        );
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackbar.showError(
          context,
          'Failed to pick image. Please try again!',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final session = sl<CurrentUser>();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated || state is AuthInitial) {
          _isUploadingNotifier.value = false;
        }

        if (state is AuthInitial) {
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
          buildWhen: (previous, current) => current is AuthAuthenticated,
          builder: (context, state) {
            if (state is! AuthAuthenticated) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  const SizedBox(height: AppSpacing.md),

                  ValueListenableBuilder<bool>(
                    valueListenable: _isUploadingNotifier,
                    builder: (context, isUploading, child) {
                      return GestureDetector(
                        onTap: isUploading
                            ? null
                            : () => _pickAndUploadImage(context, state.userId),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: colorScheme.primary.withAlpha(
                                40,
                              ),
                              backgroundImage:
                                  state.profilePicture != null &&
                                      state.profilePicture!.isNotEmpty
                                  ? FileImage(io.File(state.profilePicture!))
                                  : null,
                              child:
                                  state.profilePicture == null ||
                                      state.profilePicture!.isEmpty
                                  ? Icon(
                                      Icons.person_rounded,
                                      size: 50,
                                      color: colorScheme.primary,
                                    )
                                  : null,
                            ),
                            if (isUploading)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withAlpha(100),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(32.0),
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  ),
                                ),
                              ),
                            if (!isUploading)
                              Positioned(
                                bottom: -2,
                                right: -2,
                                child: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: colorScheme.surface,
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
                              ),
                          ],
                        ),
                      );
                    },
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
                    backgroundColor: colorScheme.error,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AppConfirmationDialog(
                          title: 'Log Out',
                          message:
                              'Are you sure you want to log out from Peso Path?',
                          confirmText: 'Log Out',
                          isDestructive: true,
                          onConfirm: () {
                            context.read<AuthBloc>().add(LogoutRequested());
                            context.go('/login');
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
