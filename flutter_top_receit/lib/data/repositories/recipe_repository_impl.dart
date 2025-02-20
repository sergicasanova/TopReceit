import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/datasources/recipe_api_datasource.dart';
import 'package:flutter_top_receit/data/models/recipe_model.dart';
import 'package:flutter_top_receit/domain/entities/recipe_entity.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_repository.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeApiDataSource recipeApiDataSource;

  RecipeRepositoryImpl(this.recipeApiDataSource);

  @override
  Future<Either<Failure, List<RecipeEntity>>> getAllRecipes() async {
    try {
      final recipeModels = await recipeApiDataSource.getAllRecipes();
      final recipes =
          recipeModels.map((model) => model.toRecipeEntity()).toList();
      return Right(recipes);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al obtener las recetas.'));
    }
  }

  @override
  Future<Either<Failure, RecipeEntity>> getRecipeById(int id) async {
    try {
      final recipeModel = await recipeApiDataSource.getRecipeById(id);
      final recipe = recipeModel.toRecipeEntity();
      return Right(recipe);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al obtener la receta.'));
    }
  }

  @override
  Future<Either<Failure, List<RecipeEntity>>> getRecipesByUserId(
      String userId) async {
    try {
      final recipeModels = await recipeApiDataSource.getRecipesByUserId(userId);
      final recipes =
          recipeModels.map((model) => model.toRecipeEntity()).toList();
      return Right(recipes);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Error al obtener las recetas del usuario.'));
    }
  }

  @override
  Future<Either<Failure, void>> createRecipe(
      String title, String description, String image, String userId) async {
    try {
      await recipeApiDataSource.createRecipe(title, description, image, userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al crear la receta.'));
    }
  }

  @override
  Future<Either<Failure, bool>> updateRecipe(UpdateRecipeDto dto) async {
    try {
      final result = await recipeApiDataSource.updateRecipe(dto);

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al actualizar la receta.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipe(int id) async {
    try {
      await recipeApiDataSource.deleteRecipe(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al eliminar la receta.'));
    }
  }
}
