import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import 'profile_provider.dart';

const List<String> kPresetAvatars = [
  'assets/images/avatar_1.png',
  'assets/images/avatar_2.png',
  'assets/images/avatar_3.png',
  'assets/images/avatar_4.png',
  'assets/images/avatar_5.png',
];

class EditProfileState {
  final String name;
  final String email;
  final String degree;
  final String avatarUrl;
  final DateTime? birthday;
  final String? phoneNumber;
  final bool isSaving;
  final String? errorMessage;
  final bool isSaved;

  const EditProfileState({
    this.name = '',
    this.email = '',
    this.degree = '',
    this.avatarUrl = 'assets/images/avatar_1.png',
    this.birthday,
    this.phoneNumber,
    this.isSaving = false,
    this.errorMessage,
    this.isSaved = false,
  });

  EditProfileState copyWith({
    String? name,
    String? email,
    String? degree,
    String? avatarUrl,
    DateTime? birthday,
    String? phoneNumber,
    bool? isSaving,
    String? errorMessage,
    bool? isSaved,
  }) {
    return EditProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      degree: degree ?? this.degree,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      birthday: birthday ?? this.birthday,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isSaving: isSaving ?? this.isSaving,
      errorMessage: errorMessage,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  final Ref ref;

  EditProfileNotifier(this.ref) : super(_buildInitialState(ref));

  static EditProfileState _buildInitialState(Ref ref) {
    final profile = ref.read(profileNotifierProvider).profile;
    if (profile != null) {
      return EditProfileState(
        name: profile.name,
        email: profile.email,
        degree: profile.degree,
        avatarUrl: profile.avatarUrl.isNotEmpty
            ? profile.avatarUrl
            : kPresetAvatars.first,
        birthday: profile.birthday,
        phoneNumber: profile.phoneNumber,
      );
    }
    return const EditProfileState();
  }

  void initFromCurrentProfile() {
    final profile = ref.read(profileNotifierProvider).profile;
    if (profile != null) {
      state = state.copyWith(
        name: profile.name,
        email: profile.email,
        degree: profile.degree,
        avatarUrl: profile.avatarUrl.isNotEmpty
            ? profile.avatarUrl
            : kPresetAvatars.first,
        birthday: profile.birthday,
        phoneNumber: profile.phoneNumber,
      );
    }
  }

  void resetForFirstTime() {
    state = const EditProfileState(
      name: '',
      email: '',
      degree: '',
      avatarUrl: 'assets/images/avatar_1.png',
      birthday: null,
      phoneNumber: '',
      isSaving: false,
      errorMessage: null,
      isSaved: false,
    );
  }

  void setName(String val) => state = state.copyWith(name: val);
  void setEmail(String val) => state = state.copyWith(email: val);
  void setDegree(String val) => state = state.copyWith(degree: val);
  void setAvatar(String val) => state = state.copyWith(avatarUrl: val);
  void setBirthday(DateTime val) => state = state.copyWith(birthday: val);
  void setPhoneNumber(String val) => state = state.copyWith(phoneNumber: val);

  Future<bool> save() async {
    if (state.name.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Please enter your name');
      return false;
    }

    state = state.copyWith(isSaving: true, errorMessage: null);

    final currentProfile = ref.read(profileNotifierProvider).profile ??
        UserProfile.defaultProfile();

    final updated = currentProfile.copyWith(
      name: state.name.trim(),
      email: state.email.trim(),
      degree: state.degree.trim(),
      avatarUrl: state.avatarUrl,
      birthday: state.birthday,
      phoneNumber: state.phoneNumber?.trim(),
      updatedAt: DateTime.now(),
    );

    final success =
        await ref.read(profileNotifierProvider.notifier).updateProfile(updated);

    state = state.copyWith(
      isSaving: false,
      isSaved: success,
      errorMessage: success ? null : 'Failed to save profile',
    );

    return success;
  }
}

final editProfileNotifierProvider =
    StateNotifierProvider.autoDispose<EditProfileNotifier, EditProfileState>(
        (ref) {
  return EditProfileNotifier(ref);
});
