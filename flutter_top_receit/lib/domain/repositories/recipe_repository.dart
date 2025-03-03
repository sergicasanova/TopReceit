import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/recipe_model.dart';
import 'package:flutter_top_receit/domain/entities/recipe_entity.dart';

abstract class RecipeRepository {
  Future<Either<Failure, List<RecipeEntity>>> getAllRecipes();
  Future<Either<Failure, RecipeEntity>> getRecipeById(int id);
  Future<Either<Failure, List<RecipeEntity>>> getRecipesByUserId(String userId);
  Future<Either<Failure, void>> createRecipe(
      String title, String description, String image, String userId);
  Future<Either<Failure, bool>> updateRecipe(UpdateRecipeDto dto);

  Future<Either<Failure, void>> deleteRecipe(int id);
  Future<Either<Failure, List<RecipeEntity>>> getPublicRecipes();
}
