import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

// Modificar el caso de uso para no depender de RecipeEntity
class CreateRecipeUseCase
    implements UseCase<Either<Failure, void>, CreateRecipeParams> {
  final RecipeRepository repository;

  CreateRecipeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateRecipeParams params) async {
    return repository.createRecipe(
        params.title, params.description, params.image, params.userId);
  }
}

class CreateRecipeParams {
  final String title;
  final String description;
  final String image;
  final String userId;

  CreateRecipeParams({
    required this.title,
    required this.description,
    required this.image,
    required this.userId,
  });
}
