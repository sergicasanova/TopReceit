import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_ingredient_repository.dart';

class DeleteRecipeIngredientUseCase {
  final RecipeIngredientRepository repository;

  DeleteRecipeIngredientUseCase(this.repository);

  Future<Either<Failure, void>> call(
      int recipeId, int idRecipeIngredient) async {
    return repository.deleteRecipeIngredient(recipeId, idRecipeIngredient);
  }
}
