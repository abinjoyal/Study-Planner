import '../../domain/entities/user_profile.dart';

class ProfileModel extends UserProfile {
  const ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.degree,
    required super.avatarUrl,
    super.birthday,
    super.phoneNumber,
    super.createdAt,
    super.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(dynamic val) {
      if (val == null) return null;
      if (val is DateTime) return val;
      if (val is String && val.isNotEmpty) {
        return DateTime.tryParse(val);
      }
      return null;
    }

    return ProfileModel(
      id: json['id'] as String? ?? 'default_user',
      name: (json['full_name'] ?? json['name']) as String? ?? 'Alex Johnson',
      email: json['email'] as String? ?? 'alex@example.com',
      degree: json['degree'] as String? ?? 'B.Sc. Computer Science',
      avatarUrl: (json['avatar_url'] ?? json['avatar']) as String? ??
          'assets/images/avatar_1.png',
      birthday: parseDateTime(json['birthday']),
      phoneNumber: json['phone_number'] as String? ?? json['phone'] as String?,
      createdAt: parseDateTime(json['created_at']),
      updatedAt: parseDateTime(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': name,
      'email': email,
      'degree': degree,
      'avatar_url': avatarUrl,
      'birthday': birthday?.toIso8601String(),
      'phone_number': phoneNumber,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory ProfileModel.fromEntity(UserProfile entity) {
    return ProfileModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      degree: entity.degree,
      avatarUrl: entity.avatarUrl,
      birthday: entity.birthday,
      phoneNumber: entity.phoneNumber,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserProfile toEntity() {
    return UserProfile(
      id: id,
      name: name,
      email: email,
      degree: degree,
      avatarUrl: avatarUrl,
      birthday: birthday,
      phoneNumber: phoneNumber,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
