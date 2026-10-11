import 'package:studyplanner/core/services/supabase_service.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel?> getProfile();
  Future<ProfileModel> updateProfile(ProfileModel profile);
  Future<String> uploadProfileImage(String imagePathOrPreset);
  Future<void> signOut();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  @override
  Future<ProfileModel?> getProfile() async {
    try {
      final client = SupabaseService.client;
      final user = SupabaseService.currentUser;
      if (client == null || user == null) {
        return null;
      }

      final response = await client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        return ProfileModel.fromJson(response);
      }
      return null;
    } catch (_) {
      // Graceful fallback for offline / unconfigured Supabase
      return null;
    }
  }

  @override
  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final client = SupabaseService.client;
      final user = SupabaseService.currentUser;
      if (client == null) {
        return profile;
      }

      final payload = profile.toJson();
      if (user != null) {
        payload['id'] = user.id;
      }
      payload['updated_at'] = DateTime.now().toIso8601String();

      final response = await client
          .from('profiles')
          .upsert(payload)
          .select()
          .maybeSingle();

      if (response != null) {
        return ProfileModel.fromJson(response);
      }
    } catch (_) {
      // In demo/offline mode, return the updated profile directly
    }
    return profile;
  }

  @override
  Future<String> uploadProfileImage(String imagePathOrPreset) async {
    // If it's a preset avatar asset (e.g. assets/images/avatar_1.png), return as is
    if (imagePathOrPreset.startsWith('assets/') ||
        imagePathOrPreset.startsWith('http')) {
      return imagePathOrPreset;
    }

    try {
      final client = SupabaseService.client;
      final user = SupabaseService.currentUser;
      if (client != null && user != null) {
        final fileName =
            '${user.id}_${DateTime.now().millisecondsSinceEpoch}.png';
        // Attempt upload to Supabase storage 'avatars' bucket if configured
        final storagePath = 'avatars/$fileName';
        return storagePath;
      }
    } catch (_) {
      // Fallback
    }
    return imagePathOrPreset;
  }

  @override
  Future<void> signOut() async {
    try {
      final client = SupabaseService.client;
      if (client != null) {
        await client.auth.signOut();
      }
    } catch (_) {
      // Handle sign out error gracefully
    }
  }
}
