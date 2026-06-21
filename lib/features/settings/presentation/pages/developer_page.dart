import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:peso_path/core/theme/app_colors.dart';
import 'package:peso_path/core/theme/app_spacing.dart';
import 'package:peso_path/shared/widgets/app_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  Future<void> _launchURL(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $urlString';
      }
    } catch (e) {
      if (context.mounted) {
        AppSnackbar.showError(context, 'Could not open link: $urlString');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.md),
            // Profile Avatar / Placeholder
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
                image: const DecorationImage(
                  image: AssetImage('lib/assets/images/dev-profile.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Jesie Gapol',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Developer',
              style: theme.textTheme.titleMedium?.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // About Developer Card
            _buildInfoCard(
              context,
              title: 'About Me',
              child: Text(
                "Hi, I'm Jesie! I am passionate about crafting highly optimized, clean-architecture mobile applications using Flutter and Dart. Peso Path was designed to deliver a robust, offline-first personal financial budgeting tool with zero user data tracking.",
                style: theme.textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // Contact / Link rows
            _buildInfoCard(
              context,
              title: 'Connect & Support',
              child: Column(
                children: [
                  _buildContactRow(
                    context,
                    iconWidget: const Icon(
                      Icons.email_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),

                    value: 'gapoljesie23@gmail.com',
                    onTap: () =>
                        _launchURL(context, 'mailto:gapoljesie23@gmail.com'),
                  ),
                  const Divider(height: AppSpacing.lg),
                  _buildContactRow(
                    context,
                    iconWidget: const FaIcon(
                      FontAwesomeIcons.github,
                      size: 20,
                      color: AppColors.primary,
                    ),

                    value: 'github.com/jcgpl-dev',
                    onTap: () =>
                        _launchURL(context, 'https://github.com/jcgpl-dev'),
                  ),
                  const Divider(height: AppSpacing.lg),
                  _buildContactRow(
                    context,
                    iconWidget: const FaIcon(
                      FontAwesomeIcons.facebook,
                      size: 20,
                      color: AppColors.primary,
                    ),

                    value: 'facebook.com/jesieperasgapol',
                    onTap: () => _launchURL(
                      context,
                      'https://facebook.com/jesieperasgapol',
                    ),
                  ),
                  const Divider(height: AppSpacing.lg),
                  _buildContactRow(
                    context,
                    iconWidget: const Icon(
                      Icons.business_center_outlined,
                      size: 20,
                      color: AppColors.primary,
                    ),

                    value: 'jcgpl-dev.github.io',
                    onTap: () =>
                        _launchURL(context, 'https://jcgpl-dev.github.io'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }

  Widget _buildContactRow(
    BuildContext context, {
    required Widget iconWidget, // Accept any Widget (Icon or FaIcon) directly

    required String value,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Center(
                child:
                    iconWidget, // Render the passed icon widget directly here
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 12,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}
