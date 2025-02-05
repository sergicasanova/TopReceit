import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/like_repository.dart';

class GetLikesByRecipeIdUseCase {
  final LikeRepository repository;

  GetLikesByRecipeIdUseCase(this.repository);

  Future<Either<Failure, List<String>>> call(int recipeId) {
    print("Getting likes by recipe id: $recipeId");
    return repository.getLikesByRecipeId(recipeId);
  }
}
