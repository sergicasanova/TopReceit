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
}
