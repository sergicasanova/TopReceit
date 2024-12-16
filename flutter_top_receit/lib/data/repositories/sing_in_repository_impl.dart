import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/datasources/firebase_auth_datasource.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/repositories/sign_in_repository.dart';

class SignInRepositoryImpl implements SignInRepository {
  final FirebaseAuthDataSource dataSource;

  SignInRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, UserModel>> signIn(
      String email, String password) async {
    try {
      UserModel user = await dataSource.signIn(email, password);
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
  Future<Either<Failure, UserModel?>> isLoggedIn() async {
    try {
      final user = await dataSource.getCurrentUser();
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: 'Error al comprobar la sesión.'));
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
      UserModel user = await dataSource.signUp(
          email, password, username, avatar, preferences);
      return Right(user);
    } catch (e) {
      return Left(AuthFailure(message: 'Error al registrar al usuario.'));
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
}
