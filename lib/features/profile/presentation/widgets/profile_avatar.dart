import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String avatarUrl;
  final double radius;
  final bool showCameraBadge;
  final VoidCallback? onCameraTap;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    required this.avatarUrl,
    this.radius = 48,
    this.showCameraBadge = true,
    this.onCameraTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? onCameraTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Outer Ring / Glowing Border
          Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFFA07A), Color(0xFFFF7A00)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF95700).withValues(alpha: 0.25),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3.0),
            child: ClipOval(
              child: _buildAvatarImage(),
            ),
          ),

          // Camera Action Badge
          if (showCameraBadge)
            Positioned(
              right: -2,
              bottom: 0,
              child: GestureDetector(
                onTap: onCameraTap ?? onTap,
                child: Container(
                  width: radius * 0.58,
                  height: radius * 0.58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF), // Vibrant iOS blue
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: radius * 0.32,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarImage() {
    if (avatarUrl.startsWith('assets/')) {
      return Image.asset(
        avatarUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(),
      );
    } else if (avatarUrl.startsWith('http')) {
      return Image.network(
        avatarUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildFallbackAvatar(),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFF95700),
            ),
          );
        },
      );
    } else {
      return _buildFallbackAvatar();
    }
  }

  Widget _buildFallbackAvatar() {
    // Stylized cute 3D-like cartoon face fallback
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF70A1FF), Color(0xFF1E90FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.face_retouching_natural_rounded,
          size: radius * 1.1,
          color: Colors.white.withValues(alpha: 0.95),
        ),
      ),
    );
  }
}
