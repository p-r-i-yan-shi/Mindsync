import 'package:flutter/material.dart';
import 'package:my_flutter/providers/theme_provider.dart';
import 'package:my_flutter/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  Future<void> _toggleNotifications(bool value) async {
    setState(() => _notificationsEnabled = value);
    if (value) {
      await NotificationService().scheduleDailyNotification(
        id: 1,
        title: 'Hey, how was your day?',
        body: 'Numa wants to talk to you 💬',
        time: const TimeOfDay(hour: 20, minute: 0),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Daily notifications enabled!')),
        );
      }
    } else {
      await NotificationService().cancelAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notifications disabled.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        elevation: 0,
        backgroundColor: AppColors.primaryDark,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18.0),
        children: [
          _buildSectionTitle('Appearance'),
          _buildCurvedCard(
            context,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Toggle between light and dark theme'),
                  value: ref.watch(themeProviderNotifier).isDarkMode,
                  onChanged: (value) => ref.read(themeProviderNotifier.notifier).toggleTheme(),
                  activeColor: AppColors.accentPurple,
                  secondary: const Icon(Icons.dark_mode, color: AppColors.accentPurple),
                ),
                const Divider(),
                const Text(
                  'Accent Color',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildColorOption(context, AppColors.accentPurple),
                    _buildColorOption(context, AppColors.accentBlue),
                    _buildColorOption(context, AppColors.accentGreen),
                    _buildColorOption(context, AppColors.accentRed),
                    _buildColorOption(context, Colors.orange),
                    _buildColorOption(context, Colors.teal),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _buildSectionTitle('Notifications'),
          _buildCurvedCard(
            context,
            SwitchListTile(
              title: const Text('Daily Reminders'),
              subtitle: const Text('Get a friendly nudge from Numa every evening.'),
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
              activeColor: AppColors.accentPurple,
              secondary: const Icon(Icons.notifications_active, color: AppColors.accentPurple),
            ),
          ),
          const SizedBox(height: 18),
          _buildSectionTitle('Account'),
          _buildCurvedCard(
            context,
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline, color: AppColors.accentPurple),
                  title: const Text('Profile'),
                  subtitle: const Text('View and edit your profile'),
                  onTap: () {
                    // TODO: Navigate to profile
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: AppColors.accentRed),
                  title: const Text('Logout'),
                  onTap: () {
                    // TODO: Add logout logic
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _buildSectionTitle('Privacy & Security'),
          _buildCurvedCard(
            context,
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock_outline, color: AppColors.accentPurple),
                  title: const Text('Privacy Policy'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.security, color: AppColors.accentPurple),
                  title: const Text('Security Settings'),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _buildSectionTitle('About & Feedback'),
          _buildCurvedCard(
            context,
            Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline, color: AppColors.accentPurple),
                  title: const Text('About App'),
                  subtitle: const Text('Version 1.0.0'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.feedback_outlined, color: AppColors.accentPurple),
                  title: const Text('Send Feedback'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.lightGrey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCurvedCard(BuildContext context, Widget child) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentPurple.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: child,
    );
  }

  Widget _buildColorOption(BuildContext context, Color color) {
    final themeProvider = ref.read(themeProviderNotifier);
    final isSelected = themeProvider.accentColor == color;

    return GestureDetector(
      onTap: () => ref.read(themeProviderNotifier.notifier).setAccentColor(color),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }
} 