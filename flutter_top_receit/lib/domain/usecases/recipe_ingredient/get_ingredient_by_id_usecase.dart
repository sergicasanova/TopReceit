import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/recipe_ingredient_entity.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_ingredient_repository.dart';

class GetIngredientByIdUseCase {
  final RecipeIngredientRepository repository;

  GetIngredientByIdUseCase(this.repository);

  Future<Either<Failure, RecipeIngredientEntity>> call(
      int idRecipeIngredient) async {
    return repository.getIngredientById(idRecipeIngredient);
  }
}
