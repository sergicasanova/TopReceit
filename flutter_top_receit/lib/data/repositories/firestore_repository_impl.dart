import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/datasources/firestore_datasource.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/repositories/firestore_repository.dart';

class FirestoreRepositoryImpl implements FirestoreRepository {
  final FirestoreDataSource firestoreDataSource;

  FirestoreRepositoryImpl({required this.firestoreDataSource});

  @override
  Future<Either<Failure, void>> createUser(UserModel user) async {
    try {
      await firestoreDataSource.createUser(user);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al crear el usuario.'));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getUser(String userId) async {
    try {
      final user = await firestoreDataSource.getUser(userId);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al obtener el usuario.'));
    }
  }

  @override
  Future<Either<Failure, void>> updateUser(UserModel user) async {
    try {
      await firestoreDataSource.updateUser(user);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al actualizar el usuario.'));
    }
  }
}
