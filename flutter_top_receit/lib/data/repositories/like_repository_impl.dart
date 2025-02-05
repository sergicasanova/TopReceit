import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/datasources/like_api_datasource.dart';
import 'package:flutter_top_receit/domain/repositories/like_repository.dart';

class LikeRepositoryImpl implements LikeRepository {
  final LikeApiDataSource likeApiDataSource;

  LikeRepositoryImpl(this.likeApiDataSource);

  @override
  Future<Either<Failure, void>> giveLike(String userId, int recipeId) async {
    try {
      await likeApiDataSource.giveLike(userId, recipeId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al dar like a la receta.'));
    }
  }

  @override
  Future<Either<Failure, void>> removeLike(String userId, int recipeId) async {
    try {
      await likeApiDataSource.removeLike(userId, recipeId);
      return const Right(null);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Error al quitar el like de la receta.'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getLikesByRecipeId(int recipeId) async {
    try {
      final likeUserIds = await likeApiDataSource.getLikesByRecipeId(recipeId);
      print(likeUserIds);
      return Right(likeUserIds);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Error al obtener los likes de la receta.'));
    }
  }
}
