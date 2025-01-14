class UserEntity {
  final String id;
  final String email;
  final String username;
  final String avatar;
  final List<String> preferences;

  UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.avatar,
    required this.preferences,
  });

  UserEntity toUserEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      avatar: avatar,
      preferences: preferences,
    );
  }

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? avatar,
    List<String>? preferences,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      preferences: preferences ?? this.preferences,
    );
  }
}
