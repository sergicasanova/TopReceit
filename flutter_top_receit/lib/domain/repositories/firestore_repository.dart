import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';

abstract class FirestoreRepository {
  Future<Either<Failure, void>> createUser(UserModel user);
  Future<Either<Failure, UserModel?>> getUser(String userId);
  Future<Either<Failure, void>> updateUser(UserModel user);
}
