import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/recipe_ingredient_entity.dart';
import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_ingredient_repository.dart';

class UpdateRecipeIngredientUseCase {
  final RecipeIngredientRepository repository;

  UpdateRecipeIngredientUseCase(this.repository);

  Future<Either<Failure, RecipeIngredientEntity>> call(
      RecipeIngredientModel recipeIngredient,
      int recipeId,
      int idRecipeIngredient) async {
    return repository.updateRecipeIngredient(
        recipeIngredient, recipeId, idRecipeIngredient);
  }
}
