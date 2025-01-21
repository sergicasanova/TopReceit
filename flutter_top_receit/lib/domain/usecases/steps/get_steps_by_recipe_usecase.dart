import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/steps_entity.dart';
import 'package:flutter_top_receit/domain/repositories/steps_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class GetStepsByRecipeUseCase
    implements UseCase<Either<Failure, List<StepEntity>>, int> {
  final StepsRepository repository;

  GetStepsByRecipeUseCase(this.repository);

  @override
  Future<Either<Failure, List<StepEntity>>> call(int recipeId) async {
    return repository.getStepsByRecipe(recipeId);
  }
}
