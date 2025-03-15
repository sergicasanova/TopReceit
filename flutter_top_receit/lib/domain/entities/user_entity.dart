import 'package:flutter_top_receit/data/models/user_model.dart';

class UserEntity {
  final String id;
  final String email;
  final String username;
  final String avatar;
  final List<String> preferences;
  final List<String> following;
  final List<String> followers;

  UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.avatar,
    required this.preferences,
    this.following = const [],
    this.followers = const [],
  });

  UserEntity toUserEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      avatar: avatar,
      preferences: preferences,
      following: following,
      followers: followers,
    );
  }

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? avatar,
    List<String>? preferences,
    List<String>? following,
    List<String>? followers,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      preferences: preferences ?? this.preferences,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }

  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      id: model.id,
      email: model.email,
      username: model.username,
      avatar: model.avatar,
      preferences: model.preferences,
      following: model.following,
      followers: model.followers,
    );
  }
}
