import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_top_receit/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String username;
  final String avatar;
  final List<String> preferences;
  final int role;
  final List<String> following;
  final List<String> followers;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.avatar,
    required this.preferences,
    this.role = 2,
    this.following = const [],
    this.followers = const [],
  });

  UserEntity toEntity() {
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

  factory UserModel.fromUserCredential(UserCredential userCredential) {
    return UserModel(
      id: userCredential.user?.uid ?? '',
      email: userCredential.user?.email ?? '',
      username: '',
      avatar: '',
      preferences: [],
      role: 2,
      following: [],
      followers: [],
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> firestoreData) {
    return UserModel(
      id: firestoreData['id'],
      email: firestoreData['email'],
      username: firestoreData['username'] ?? '',
      avatar: firestoreData['avatar'] ?? '',
      preferences: List<String>.from(firestoreData['preferences'] ?? []),
      role: firestoreData['role'] ?? 2,
      // following: List<String>.from(firestoreData['following'] ?? []),
      // followers: List<String>.from(firestoreData['followers'] ?? []),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id_user'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      avatar: json['avatar'] ?? '',
      preferences: List<String>.from(json['preferences'] ?? []),
      role: json['role'] ?? 2,
      following: (json['following'] as List<dynamic>?)
              ?.map((item) => item['id'] as String)
              .toList() ??
          [],
      followers: (json['followers'] as List<dynamic>?)
              ?.map((item) => item['id'] as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar': avatar,
      'preferences': preferences,
      'role': role,
      'following': following,
      'followers': followers,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id,
      'email': email,
      'username': username,
      'avatar': avatar,
      'preferences': preferences,
      'role': role,
      'following': following,
      'followers': followers,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? avatar,
    List<String>? preferences,
    int? role,
    List<String>? following,
    List<String>? followers,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      preferences: preferences ?? this.preferences,
      role: role ?? this.role,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }
}
