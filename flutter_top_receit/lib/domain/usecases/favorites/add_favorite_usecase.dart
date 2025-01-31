import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/favorites_repository.dart';

class AddFavoriteUseCase {
  final FavoriteRepository repository;

  AddFavoriteUseCase(this.repository);

  Future<Either<Failure, void>> call(String userId, int recipeId) {
    return repository.addFavorite(userId, recipeId);
  }
}
