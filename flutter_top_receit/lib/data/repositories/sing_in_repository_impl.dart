import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/datasources/firebase_auth_datasource.dart';
import 'package:flutter_top_receit/data/datasources/firestore_datasource.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/repositories/sign_in_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInRepositoryImpl implements SignInRepository {
  final FirebaseAuthDataSource dataSource;
  final SharedPreferences sharedPreferences;
  final FirestoreDataSource firebaseAuthDataSource;

  SignInRepositoryImpl(
      this.dataSource, this.sharedPreferences, this.firebaseAuthDataSource);

  @override
  Future<Either<Failure, UserModel>> signIn(
      String email, String password) async {
    try {
      UserModel user = await dataSource.signIn(email, password);
      await sharedPreferences.setString('email', user.email);
      await sharedPreferences.setString('id', user.id);
      return Right(user);
    } catch (e) {
      if (e is FirebaseAuthException) {
        return Left(AuthFailure(
            message: 'Credenciales incorrectas. Intenta nuevamente.'));
      }
      return Left(ServerFailure(message: 'Ocurrió un error inesperado.'));
    }
  }

  @override
  Future<Either<Failure, String>> isLoggedIn() async {
    try {
      final id = sharedPreferences.getString('id');
      if (id == null) {
        return Right("NO_USER");
      } else {
        return Right(id);
      }
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await dataSource.logout();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInGoogle() async {
    try {
      UserModel user = await dataSource.signInWithGoogle();
      return Right(user);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, UserModel>> signUp(String email, String password,
      String username, String avatar, List<String> preferences) async {
    try {
      UserModel user = await dataSource.signUp(email, password);
      firebaseAuthDataSource.createUser(
          user.email, username, avatar, preferences, user.id);
      await sharedPreferences.setString('email', user.email);
      await sharedPreferences.setString('id', user.id);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await dataSource.resetPassword(email);
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isEmailUsed(String email) async {
    try {
      bool isUsed = await firebaseAuthDataSource.isEmailUsed(email);
      return Right(isUsed);
    } catch (e) {
      return Left(AuthFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> isNameUsed(String name) async {
    try {
      bool isUsed = await firebaseAuthDataSource.isNameUsed(name);
      return Right(isUsed);
    } catch (e) {
      return Left(AuthFailure());
    }
  }
}
