import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfile {
  final ProfileRepository repository;

  UpdateProfile(this.repository);

  Future<UserProfile> call(UserProfile profile) async {
    return await repository.updateProfile(profile);
  }
}
