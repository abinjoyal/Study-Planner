import 'package:flutter/material.dart';
import '../../domain/entities/user_profile.dart';
import 'edit_profile_button.dart';
import 'profile_avatar.dart';

class ProfileInfoCard extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onEditPressed;
  final VoidCallback onAvatarPressed;

  const ProfileInfoCard({
    super.key,
    required this.profile,
    required this.onEditPressed,
    required this.onAvatarPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFF5EB), // Warm light peach
            Color(0xFFFFE8D6), // Soft warm cream
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE2B08B).withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative background circular blob (as in screenshot)
            Positioned(
              right: -30,
              top: -20,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFD8B8).withValues(alpha: 0.45),
                ),
              ),
            ),
            Positioned(
              right: 20,
              bottom: -40,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFCCA3).withValues(alpha: 0.35),
                ),
              ),
            ),

            // Card Content
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Avatar with Camera Badge
                  ProfileAvatar(
                    avatarUrl: profile.avatarUrl,
                    radius: 46,
                    showCameraBadge: true,
                    onCameraTap: onAvatarPressed,
                    onTap: onAvatarPressed,
                  ),
                  const SizedBox(width: 16),

                  // User Information
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          profile.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            letterSpacing: -0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          profile.email,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),

                        // Degree with graduation cap icon
                        Row(
                          children: [
                            const Text('🎓 ', style: TextStyle(fontSize: 13)),
                            Expanded(
                              child: Text(
                                profile.degree,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFD9531E),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Edit Profile Pill Button
                        EditProfileButton(
                          onPressed: onEditPressed,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
