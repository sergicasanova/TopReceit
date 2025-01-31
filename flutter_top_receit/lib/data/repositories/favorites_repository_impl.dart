import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/datasources/favorites_api_datasource.dart';
import 'package:flutter_top_receit/domain/repositories/favorites_repository.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteApiDataSource favoriteApiDataSource;

  FavoriteRepositoryImpl(this.favoriteApiDataSource);

  @override
  Future<Either<Failure, void>> addFavorite(String userId, int recipeId) async {
    try {
      await favoriteApiDataSource.addFavorite(userId, recipeId);
      return const Right(null);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Error al agregar la receta a favoritos.'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite(
      String userId, int recipeId) async {
    try {
      await favoriteApiDataSource.removeFavorite(userId, recipeId);
      return const Right(null);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Error al eliminar la receta de favoritos.'));
    }
  }

  @override
  Future<Either<Failure, List<int>>> getFavoritesByUserId(String userId) async {
    try {
      final favoriteIds =
          await favoriteApiDataSource.getFavoritesByUserId(userId);
      return Right(favoriteIds);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Error al obtener los favoritos del usuario.'));
    }
  }
}
