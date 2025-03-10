import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/recipe_ingredient_entity.dart';
import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';

abstract class RecipeIngredientRepository {
  Future<Either<Failure, List<RecipeIngredientEntity>>>
      getAllIngredientsForRecipe(int recipeId);
  Future<Either<Failure, RecipeIngredientEntity>> getIngredientById(
      int idRecipeIngredient);
  Future<Either<Failure, RecipeIngredientEntity>> createRecipeIngredient(
      RecipeIngredientModel recipeIngredient);
  Future<Either<Failure, RecipeIngredientEntity>> updateRecipeIngredient(
      RecipeIngredientModel recipeIngredient, int idRecipeIngredient);
  Future<Either<Failure, void>> deleteRecipeIngredient(int idRecipeIngredient);
}
