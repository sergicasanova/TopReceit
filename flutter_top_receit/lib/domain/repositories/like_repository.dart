import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';

abstract class LikeRepository {
  Future<Either<Failure, void>> giveLike(String userId, int recipeId);
  Future<Either<Failure, void>> removeLike(String userId, int recipeId);
  Future<Either<Failure, List<String>>> getLikesByRecipeId(int recipeId);
}
