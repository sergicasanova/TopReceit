import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/recipe_entity.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class GetRecipeByIdUseCase
    implements UseCase<Either<Failure, RecipeEntity>, int> {
  final RecipeRepository repository;

  GetRecipeByIdUseCase(this.repository);

  @override
  Future<Either<Failure, RecipeEntity>> call(int id) async {
    return repository.getRecipeById(id);
  }
}
