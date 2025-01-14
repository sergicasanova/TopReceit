import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';

class FirestoreDataSource {
  Future<void> createUser(String email, String username, String avatar,
      List<String> preferences, String id) async {
    try {
      DocumentReference users =
          FirebaseFirestore.instance.collection('users').doc(id);
      await users.set({
        'email': email,
        'username': username,
        'avatar': avatar,
        'preferences': preferences,
        'role': 2,
      });
    } catch (e) {
      throw Exception('Error al crear el usuario en Firestore: $e');
    }
  }

  Future<bool> isEmailUsed(String email) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot snapshot = await users.where('email', isEqualTo: email).get();
    if (snapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> isNameUsed(String name) async {
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    QuerySnapshot snapshot = await users.where('name', isEqualTo: name).get();
    if (snapshot.docs.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // Future<UserModel?> getUser(String userId) async {
  //   try {
  //     final userDoc = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(userId)
  //         .get();
  //     if (userDoc.exists) {
  //       final userData = userDoc.data()!;
  //       return UserModel.fromFirestore(userData);
  //     }
  //     return null;
  //   } catch (e) {
  //     throw Exception('Error al obtener el usuario desde Firestore: $e');
  //   }
  // }

  Future<void> updateUser(UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).update({
        'username': user.username,
        'avatar': user.avatar,
        'preferences': user.preferences,
      });
    } catch (e) {
      throw Exception('Error al actualizar el usuario en Firestore: $e');
    }
  }
}
