import 'package:flutter/material.dart';
import 'notification_button.dart';

class HomeHeader extends StatelessWidget {
  final String studentName;
  final bool hasNotification;
  final VoidCallback onNotificationTap;

  const HomeHeader({
    super.key,
    required this.studentName,
    required this.hasNotification,
    required this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const Text(
              '👋 ',
              style: TextStyle(fontSize: 26),
            ),
            const SizedBox(width: 4),
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
