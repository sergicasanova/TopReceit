import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';

abstract class SignInRepository {
  Future<Either<Failure, UserModel>> signIn(String email, String password);
  Future<Either<Failure, UserModel>> signInGoogle();
  Future<Either<Failure, String>> isLoggedIn();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, UserModel>> signUp(String email, String password,
      String username, String avatar, List<String> preferences);
  Future<Either<Failure, void>> resetPassword(String email);
  Future<Either<Failure, bool>> isEmailUsed(String email);
  Future<Either<Failure, bool>> isNameUsed(String name);
}
