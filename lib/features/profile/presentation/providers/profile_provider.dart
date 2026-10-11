import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/update_profile.dart';
import '../../domain/usecases/upload_profile_image.dart';

// Dependency Injection Providers
final profileLocalDataSourceProvider =
    Provider<ProfileLocalDataSource>((ref) {
  return ProfileLocalDataSourceImpl();
});

final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  return ProfileRemoteDataSourceImpl();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.watch(profileRemoteDataSourceProvider),
    localDataSource: ref.watch(profileLocalDataSourceProvider),
  );
});

final getProfileUseCaseProvider = Provider<GetProfile>((ref) {
  return GetProfile(ref.watch(profileRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfile>((ref) {
  return UpdateProfile(ref.watch(profileRepositoryProvider));
});

final uploadProfileImageUseCaseProvider = Provider<UploadProfileImage>((ref) {
  return UploadProfileImage(ref.watch(profileRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOut>((ref) {
  return SignOut(ref.watch(profileRepositoryProvider));
});

// Profile State Model
class ProfileState {
  final bool isLoading;
  final UserProfile? profile;
  final String? errorMessage;
  final bool isSuccess;

  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.errorMessage,
    this.isSuccess = false,
  });

  ProfileState copyWith({
    bool? isLoading,
    UserProfile? profile,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

// Profile Notifier
class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetProfile getProfileUseCase;
  final UpdateProfile updateProfileUseCase;
  final UploadProfileImage uploadProfileImageUseCase;
  final SignOut signOutUseCase;

  ProfileNotifier({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.uploadProfileImageUseCase,
    required this.signOutUseCase,
  }) : super(const ProfileState(isLoading: true)) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final userProfile = await getProfileUseCase();
      state = state.copyWith(
        isLoading: false,
        profile: userProfile,
        isSuccess: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> updateProfile(UserProfile updated) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final result = await updateProfileUseCase(updated);
      state = state.copyWith(
        isLoading: false,
        profile: result,
        isSuccess: true,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
      return false;
    }
  }

  Future<void> updateAvatar(String avatarPathOrPreset) async {
    final current = state.profile;
    if (current == null) return;

    try {
      final uploadedPath = await uploadProfileImageUseCase(avatarPathOrPreset);
      final updated = current.copyWith(avatarUrl: uploadedPath);
      await updateProfile(updated);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    try {
      await signOutUseCase();
      state = const ProfileState(isLoading: false, profile: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(
    getProfileUseCase: ref.watch(getProfileUseCaseProvider),
    updateProfileUseCase: ref.watch(updateProfileUseCaseProvider),
    uploadProfileImageUseCase: ref.watch(uploadProfileImageUseCaseProvider),
    signOutUseCase: ref.watch(signOutUseCaseProvider),
  );
});
