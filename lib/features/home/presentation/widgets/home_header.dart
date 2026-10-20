import 'package:flutter/material.dart';
import '../../../profile/presentation/widgets/profile_avatar.dart';
import 'notification_button.dart';

class HomeHeader extends StatelessWidget {
  final String studentName;
  final String? avatarUrl;
  final bool hasNotification;
  final VoidCallback onNotificationTap;
  final VoidCallback? onAvatarTap;

  const HomeHeader({
    super.key,
    required this.studentName,
    this.avatarUrl,
    required this.hasNotification,
    required this.onNotificationTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            ProfileAvatar(
              avatarUrl: avatarUrl ?? 'assets/images/avatar_1.png',
              radius: 22,
              showCameraBadge: false,
              onTap: onAvatarTap,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi, $studentName!',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F172A),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  "Let's make today productive",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ],
        ),
        NotificationButton(
          hasNotification: hasNotification,
          onTap: onNotificationTap,
        ),
      ],
    );
  }
}

