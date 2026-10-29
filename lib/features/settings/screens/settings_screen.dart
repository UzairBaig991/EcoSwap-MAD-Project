import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../main.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out of EcoSwap?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(dialogCtx);
              await ref.read(authControllerProvider.notifier).signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          // Account Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'ACCOUNT & PROFILE',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: const Text('Edit Profile'),
            subtitle: const Text('Update avatar photo, display name, and city'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/edit-profile'),
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded),
            title: const Text('Password & Security'),
            subtitle: const Text('Manage your password and sign-in methods'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => context.push('/forgot-password'),
          ),
          const Divider(height: 24),

          // Appearance & Preferences Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'PREFERENCES',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
          SwitchListTile(
            secondary: Icon(
              isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: isDarkMode ? Colors.amber : theme.colorScheme.primary,
            ),
            title: const Text('Dark Theme Mode'),
            subtitle: Text(isDarkMode ? 'Dark mode enabled' : 'Light mode enabled'),
            value: isDarkMode,
            onChanged: (val) {
              ref.read(themeModeProvider.notifier).state =
                  val ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_none_rounded),
            title: const Text('Push Notifications'),
            subtitle: const Text('Receive swap offers, chat alerts, and challenge updates'),
            value: settings.notificationsEnabled,
            onChanged: (val) => settingsNotifier.toggleNotifications(val),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up_outlined),
            title: const Text('In-App Sounds'),
            subtitle: const Text('Play sound effects on new chat messages'),
            value: settings.soundEnabled,
            onChanged: (val) => settingsNotifier.toggleSound(val),
          ),
          const Divider(height: 24),

          // About Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'ABOUT',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('App Version'),
            subtitle: const Text('${AppConstants.appName} v1.0.0'),
          ),
          ListTile(
            leading: const Icon(Icons.nature_people_outlined),
            title: const Text('Mission & Carbon Tracking'),
            subtitle: const Text('Empowering local communities to give, swap & reuse'),
            onTap: () => context.push('/carbon-dashboard'),
          ),
          const Divider(height: 24),

          // Log Out Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error.withOpacity(0.1),
                foregroundColor: AppColors.error,
                elevation: 0,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.logout_rounded, color: AppColors.error),
              label: const Text(
                'Log Out of Account',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => _showLogoutDialog(context, ref),
            ),
          ),
        ],
      ),
    );
  }
}
