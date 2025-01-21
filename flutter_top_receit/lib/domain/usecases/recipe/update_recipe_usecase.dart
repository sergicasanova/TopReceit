import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/recipe_model.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class UpdateRecipeUseCase
    implements UseCase<Either<Failure, bool>, UpdateRecipeDto> {
  final RecipeRepository repository;

  UpdateRecipeUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UpdateRecipeDto dto) async {
    return repository.updateRecipe(dto);
  }
}
