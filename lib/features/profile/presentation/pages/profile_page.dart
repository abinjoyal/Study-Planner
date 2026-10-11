import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studyplanner/features/onboarding/pages/onboarding_page.dart';
import '../../domain/entities/user_profile.dart';
import '../providers/profile_provider.dart';
import '../widgets/profile_bottom_navigation.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_menu_list.dart';
import '../widgets/profile_section_title.dart';
import 'appearance_page.dart';
import 'edit_profile_page.dart';

class ProfilePage extends ConsumerWidget {
  final bool showBottomNav;

  const ProfilePage({
    super.key,
    this.showBottomNav = false,
  });

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(profileNotifierProvider.notifier);
    await notifier.signOut();

    if (context.mounted) {
      // Clear navigation history and navigate back to initial/onboarding screen
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const OnboardingPage(),
        ),
        (route) => false,
      );
    }
  }

  void _openEditProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const EditProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final userProfile =
        profileState.profile ?? UserProfile.defaultProfile();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF9F6),
      bottomNavigationBar: showBottomNav
          ? ProfileBottomNavigation(
              selectedIndex: 4,
              onItemTapped: (index) {
                Navigator.of(context).pop();
              },
            )
          : null,
      body: SafeArea(
        child: profileState.isLoading && profileState.profile == null
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFF95700),
                ),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(profileNotifierProvider.notifier).loadProfile(),
                color: const Color(0xFFF95700),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 12.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),

                      // 1. Profile Header ("My Profile" + Settings Icon)
                      ProfileHeader(
                        onSettingsTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const AppearancePage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // 2. Profile Info Card (Peach Gradient + 3D Avatar + Edit Button)
                      ProfileInfoCard(
                        profile: userProfile,
                        onEditPressed: () => _openEditProfile(context),
                        onAvatarPressed: () => _openEditProfile(context),
                      ),
                      const SizedBox(height: 24),

                      // 3. Section Title ("Account")
                      const ProfileSectionTitle(title: 'Account'),
                      const SizedBox(height: 12),

                      // 4. Menu Items List & Logout Action
                      ProfileMenuList(
                        onLogout: () => _handleLogout(context, ref),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
