import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/appearance_page.dart';
import '../pages/help_support_page.dart';
import '../pages/notification_settings_page.dart';
import '../pages/personal_information_page.dart';
import '../pages/privacy_security_page.dart';
import '../pages/study_goals_page.dart';
import '../providers/profile_settings_provider.dart';
import 'logout_button.dart';
import 'profile_menu_item.dart';

class ProfileMenuList extends ConsumerWidget {
  final Future<void> Function() onLogout;

  const ProfileMenuList({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(profileSettingsNotifierProvider);
    final primaryColor = settings.activeColor;
    final primaryBgColor = primaryColor.withValues(alpha: 0.12);

    return Column(
      children: [
        // 1. Personal Information
        ProfileMenuItem(
          icon: Icons.person_rounded,
          iconColor: primaryColor,
          iconBackgroundColor: primaryBgColor,
          title: 'Personal Information',
          subtitle: 'Update your name, email and degree',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PersonalInformationPage(),
              ),
            );
          },
        ),

        // 2. Notifications & Reminders
        ProfileMenuItem(
          icon: Icons.notifications_rounded,
          iconColor: primaryColor,
          iconBackgroundColor: primaryBgColor,
          title: 'Notifications & Reminders',
          subtitle: 'Manage your study reminders',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const NotificationSettingsPage(),
              ),
            );
          },
        ),

        // 3. Study Goals
        ProfileMenuItem(
          icon: Icons.track_changes_rounded,
          iconColor: primaryColor,
          iconBackgroundColor: primaryBgColor,
          title: 'Study Goals',
          subtitle: 'Set and track your learning goals',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const StudyGoalsPage(),
              ),
            );
          },
        ),

        // 4. Appearance
        ProfileMenuItem(
          icon: Icons.palette_rounded,
          iconColor: primaryColor,
          iconBackgroundColor: primaryBgColor,
          title: 'Appearance',
          subtitle: 'Theme, color and display settings',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AppearancePage(),
              ),
            );
          },
        ),

        // 5. Privacy & Security
        ProfileMenuItem(
          icon: Icons.shield_rounded,
          iconColor: primaryColor,
          iconBackgroundColor: primaryBgColor,
          title: 'Privacy & Security',
          subtitle: 'Manage your data and privacy',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const PrivacySecurityPage(),
              ),
            );
          },
        ),

        // 6. Help & Support
        ProfileMenuItem(
          icon: Icons.help_rounded,
          iconColor: primaryColor,
          iconBackgroundColor: primaryBgColor,
          title: 'Help & Support',
          subtitle: 'Get help or contact us',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const HelpSupportPage(),
              ),
            );
          },
        ),

        // 7. Log Out Action
        // LogoutButton(
        //   onLogout: onLogout,
        // ),
      ],
    );
  }
}
