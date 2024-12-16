import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/repositories/firestore_repository.dart';

class GetUserUseCase {
  final FirestoreRepository firestoreRepository;

  GetUserUseCase(this.firestoreRepository);

  Future<Either<Failure, UserModel?>> call(String userId) async {
    try {
      final result = await firestoreRepository.getUser(userId);

      return result.fold(
        (failure) => Left(failure),
        (user) => Right(user),
      );
    } catch (e) {
      return Left(
          ServerFailure(message: 'Error al obtener el usuario usecase.'));
    }
  }
}
