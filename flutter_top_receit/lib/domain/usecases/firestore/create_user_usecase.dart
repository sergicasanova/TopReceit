import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/repositories/firestore_repository.dart';

class CreateUserUseCase {
  final FirestoreRepository firestoreRepository;

  CreateUserUseCase(this.firestoreRepository);

  Future<Either<Failure, UserModel>> call(UserModel user) async {
    try {
      await firestoreRepository.createUser(user);
      return Right(user);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Error al crear el usuario en Firestore.'));
    }
  }
}
