class UserProfile {
  final String id;
  final String name;
  final String email;
  final String degree;
  final String avatarUrl;
  final DateTime? birthday;
  final String? phoneNumber;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.degree,
    required this.avatarUrl,
    this.birthday,
    this.phoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? degree,
    String? avatarUrl,
    DateTime? birthday,
    String? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      degree: degree ?? this.degree,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      birthday: birthday ?? this.birthday,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static UserProfile defaultProfile() {
    return UserProfile(
      id: 'default_user',
      name: 'Alex Johnson',
      email: 'alex@example.com',
      degree: 'B.Sc. Computer Science',
      avatarUrl: 'assets/images/avatar_1.png',
      birthday: DateTime(2003, 5, 14),
      phoneNumber: '+1 234 567 8900',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
