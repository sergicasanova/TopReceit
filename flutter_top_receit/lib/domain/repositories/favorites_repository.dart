import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';

abstract class FavoriteRepository {
  Future<Either<Failure, void>> addFavorite(String userId, int recipeId);
  Future<Either<Failure, void>> removeFavorite(String userId, int recipeId);
  Future<Either<Failure, List<int>>> getFavoritesByUserId(String userId);
}
