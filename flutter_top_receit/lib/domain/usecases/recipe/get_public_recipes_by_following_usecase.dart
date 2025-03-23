import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/recipe_entity.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class GetPublicRecipesByFollowingUseCase
    implements UseCase<Either<Failure, List<RecipeEntity>>, String> {
  final RecipeRepository repository;

  GetPublicRecipesByFollowingUseCase(this.repository);

  @override
  Future<Either<Failure, List<RecipeEntity>>> call(String userId) async {
    return repository.getPublicRecipesByFollowing(userId);
  }
}
