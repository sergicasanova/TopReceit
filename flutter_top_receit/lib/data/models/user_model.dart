import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String email;
  final String username;
  final String avatar;
  final List<String> preferences;

  UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.avatar,
    required this.preferences,
  });

  factory UserModel.fromUserCredential(UserCredential userCredential) {
    return UserModel(
      id: userCredential.user?.uid ?? '',
      email: userCredential.user?.email ?? '',
      username: '',
      avatar: '',
      preferences: [],
    );
  }

  factory UserModel.fromFirestore(Map<String, dynamic> firestoreData) {
    return UserModel(
      id: firestoreData['id'],
      email: firestoreData['email'],
      username: firestoreData['username'] ?? '',
      avatar: firestoreData['avatar'] ?? '',
      preferences: List<String>.from(firestoreData['preferences'] ?? []),
    );
  }

  // Método para convertir a mapa para subir a Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar': avatar,
      'preferences': preferences,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? username,
    String? avatar,
    List<String>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      preferences: preferences ?? this.preferences,
    );
  }
}
