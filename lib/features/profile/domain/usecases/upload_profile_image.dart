import '../repositories/profile_repository.dart';

class UploadProfileImage {
  final ProfileRepository repository;

  UploadProfileImage(this.repository);

  Future<String> call(String imagePathOrPreset) async {
    return await repository.uploadProfileImage(imagePathOrPreset);
  }
}
