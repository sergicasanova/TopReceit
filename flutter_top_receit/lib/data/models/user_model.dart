import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_top_receit/domain/entities/user_entity.dart';

class UserModel {
  final String id;
  final String email;
  final String username;
  final String avatar;
  final List<String> preferences;
  final int role;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.avatar,
    required this.preferences,
    this.role = 2,
  });

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      avatar: avatar,
      preferences: preferences,
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
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? avatar,
    List<String>? preferences,
    int? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      preferences: preferences ?? this.preferences,
      role: role ?? this.role,
    );
  }
}
