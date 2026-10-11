import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_datasource.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserProfile> getProfile() async {
    // 1. Try fetching from remote
    try {
      final remoteProfile = await remoteDataSource.getProfile();
      if (remoteProfile != null) {
        await localDataSource.cacheProfile(remoteProfile);
        return remoteProfile.toEntity();
      }
    } catch (_) {
      // Remote failed, proceed to local cache
    }

    // 2. Try fetching from local cache
    try {
      final cachedProfile = await localDataSource.getCachedProfile();
      if (cachedProfile != null) {
        return cachedProfile.toEntity();
      }
    } catch (_) {
      // Local cache failed
    }

    // 3. Fallback to default user profile and cache it
    final defaultModel = ProfileModel.fromEntity(UserProfile.defaultProfile());
    await localDataSource.cacheProfile(defaultModel);
    return defaultModel.toEntity();
  }

  @override
  Future<UserProfile> updateProfile(UserProfile profile) async {
    final model = ProfileModel.fromEntity(profile);

    // Cache locally immediately (optimistic offline-first)
    await localDataSource.cacheProfile(model);

    // Sync to remote datasource
    try {
      final updatedModel = await remoteDataSource.updateProfile(model);
      await localDataSource.cacheProfile(updatedModel);
      return updatedModel.toEntity();
    } catch (_) {
      // Even if remote sync fails, return the locally cached profile
      return model.toEntity();
    }
  }

  @override
  Future<String> uploadProfileImage(String imagePathOrPreset) async {
    return await remoteDataSource.uploadProfileImage(imagePathOrPreset);
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
    await localDataSource.clearCache();
  }
}
