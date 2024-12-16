import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/data/repositories/firestore_repository_impl.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth auth;
  final FirestoreRepositoryImpl? firestoreRepository;

  FirebaseAuthDataSource({required this.auth, this.firestoreRepository});

  Future<UserModel> signIn(String email, String password) async {
    UserCredential userCredentials =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final userModel = UserModel.fromUserCredential(userCredentials);
    await _saveUserToPreferences(userModel);
    return userModel;
  }

  Future<void> logout() async {
    await auth.signOut();
    await _clearUserFromPreferences();
  }

  Future<UserModel?> getCurrentUser() async {
    final user = auth.currentUser;
    if (user != null) {
      UserModel userModel = UserModel(
        id: user.uid,
        email: user.email ?? "NO_EMAIL",
        username: '',
        avatar: '',
        preferences: [],
      );

      final result = await firestoreRepository?.getUser(user.uid);

      return result?.fold(
        (failure) => null,
        (firestoreUser) => firestoreUser?.copyWith(
          id: user.uid,
          email: user.email ?? "NO_EMAIL",
        ),
      );
    } else {
      return null;
    }
  }

  Future<UserModel> signInWithGoogle() async {
    UserCredential userCredentials;
    if (kIsWeb) {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

      userCredentials =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } else {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      userCredentials =
          await FirebaseAuth.instance.signInWithCredential(credential);
    }
    final userModel = UserModel.fromUserCredential(userCredentials);
    await _saveUserToPreferences(userModel);
    return userModel;
  }

  Future<UserModel> signUp(String email, String password, String username,
      String avatar, List<String> preferences) async {
    try {
      UserCredential userCredentials = await auth
          .createUserWithEmailAndPassword(email: email, password: password);

      UserModel user = UserModel(
        id: userCredentials.user?.uid ?? '',
        email: userCredentials.user?.email ?? '',
        username: username,
        avatar: avatar,
        preferences: preferences,
      );
      await firestoreRepository?.createUser(user);

      return user;
    } catch (e) {
      throw AuthFailure(message: 'Error al registrar al usuario.');
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          throw AuthFailure(
              message: 'No se encontró un usuario con ese correo.');
        }
      }
      throw AuthFailure(
          message: 'Error al enviar el correo de restablecimiento.');
    }
  }

  Future<void> _saveUserToPreferences(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', user.id);
    await prefs.setString('userEmail', user.email);
  }

  Future<UserModel?> _getUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userEmail = prefs.getString('userEmail');

    if (userId != null && userEmail != null) {
      return UserModel(
        id: userId,
        email: userEmail,
        username: '',
        avatar: '',
        preferences: [],
      );
    }
    return null;
  }

  Future<void> _clearUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('userEmail');
  }
}
