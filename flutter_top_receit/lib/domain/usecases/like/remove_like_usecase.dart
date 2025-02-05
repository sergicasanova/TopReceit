import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/like_repository.dart';

class RemoveLikeUseCase {
  final LikeRepository repository;

  RemoveLikeUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId, int recipeId) {
    return repository.removeLike(userId, recipeId);
  }
}
