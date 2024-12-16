import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';

class FirestoreDataSource {
  final FirebaseFirestore firestore;

  FirestoreDataSource({required this.firestore});

  Future<void> createUser(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.id).set({
        'email': user.email,
        'username': user.username,
        'avatar': user.avatar,
        'preferences': user.preferences,
        'role': 2,
      });
    } catch (e) {
      throw Exception('Error al crear el usuario en Firestore: $e');
    }
  }

  Future<UserModel?> getUser(String userId) async {
    try {
      final userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        return UserModel.fromFirestore(userData);
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener el usuario desde Firestore: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.id).update({
        'username': user.username,
        'avatar': user.avatar,
        'preferences': user.preferences,
      });
    } catch (e) {
      throw Exception('Error al actualizar el usuario en Firestore: $e');
    }
  }
}
