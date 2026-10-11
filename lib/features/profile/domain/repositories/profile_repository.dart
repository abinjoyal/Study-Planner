import '../entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getProfile();
  Future<UserProfile> updateProfile(UserProfile profile);
  Future<String> uploadProfileImage(String imagePathOrPreset);
  Future<void> signOut();
}
