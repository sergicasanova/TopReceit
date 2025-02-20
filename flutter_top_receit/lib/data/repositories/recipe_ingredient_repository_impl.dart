import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/datasources/recipe_ingredient_api_datasource.dart';
import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';
import 'package:flutter_top_receit/domain/entities/recipe_ingredient_entity.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_ingredient_repository.dart';

class RecipeIngredientRepositoryImpl implements RecipeIngredientRepository {
  final RecipeIngredientApiDataSource recipeIngredientApiDataSource;

  RecipeIngredientRepositoryImpl(this.recipeIngredientApiDataSource);

  @override
  Future<Either<Failure, List<RecipeIngredientEntity>>>
      getAllIngredientsForRecipe(int recipeId) async {
    try {
      final recipeIngredientModels = await recipeIngredientApiDataSource
          .getAllIngredientsForRecipe(recipeId);
      final recipeIngredients = recipeIngredientModels
          .map((model) => RecipeIngredientEntity.fromModel(model))
          .toList();
      return Right(recipeIngredients);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Error al obtener los ingredientes de la receta.'));
    }
  }

  @override
  Future<Either<Failure, RecipeIngredientEntity>> getIngredientById(
      int idRecipeIngredient) async {
    try {
      final recipeIngredientModel = await recipeIngredientApiDataSource
          .getIngredientById(idRecipeIngredient);
      final recipeIngredient =
          RecipeIngredientEntity.fromModel(recipeIngredientModel);
      return Right(recipeIngredient);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al obtener el ingrediente.'));
    }
  }

  @override
  Future<Either<Failure, RecipeIngredientEntity>> createRecipeIngredient(
      RecipeIngredientModel recipeIngredient) async {
    try {
      final newRecipeIngredient = await recipeIngredientApiDataSource
          .createRecipeIngredient(recipeIngredient);
      return Right(RecipeIngredientEntity.fromModel(newRecipeIngredient));
    } catch (e) {
      return Left(ServerFailure(
          message: 'Error al crear el ingrediente en la receta.'));
    }
  }

  @override
  Future<Either<Failure, RecipeIngredientEntity>> updateRecipeIngredient(
      RecipeIngredientModel recipeIngredient,
      int recipeId,
      int idRecipeIngredient) async {
    try {
      final updatedRecipeIngredient =
          await recipeIngredientApiDataSource.updateRecipeIngredient(
              recipeIngredient, recipeId, idRecipeIngredient);
      return Right(RecipeIngredientEntity.fromModel(updatedRecipeIngredient));
    } catch (e) {
      return Left(ServerFailure(
          message: 'Error al actualizar el ingrediente en la receta.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipeIngredient(
      int idRecipeIngredient) async {
    try {
      await recipeIngredientApiDataSource
          .deleteRecipeIngredient(idRecipeIngredient);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Error al eliminar el ingrediente de la receta.'));
    }
  }
}
