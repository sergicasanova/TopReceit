import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class DeleteRecipeUseCase implements UseCase<Either<Failure, void>, int> {
  final RecipeRepository repository;

  DeleteRecipeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) async {
    return repository.deleteRecipe(id);
  }
}
