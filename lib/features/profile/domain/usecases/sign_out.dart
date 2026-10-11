import '../repositories/profile_repository.dart';

class SignOut {
  final ProfileRepository repository;

  SignOut(this.repository);

  Future<void> call() async {
    return await repository.signOut();
  }
}
