import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel?> getCachedProfile();
  Future<void> cacheProfile(ProfileModel profile);
  Future<void> clearCache();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const String _profileKey = 'cached_user_profile';

  @override
  Future<ProfileModel?> getCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    if (profileJson != null && profileJson.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(profileJson);
        return ProfileModel.fromJson(decoded);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  @override
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}
