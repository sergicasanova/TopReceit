import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/recipe_ingredient_entity.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_ingredient_repository.dart';

class GetAllIngredientsForRecipeUseCase {
  final RecipeIngredientRepository repository;

  GetAllIngredientsForRecipeUseCase(this.repository);

  Future<Either<Failure, List<RecipeIngredientEntity>>> call(
      int recipeId) async {
    return repository.getAllIngredientsForRecipe(recipeId);
  }
}
