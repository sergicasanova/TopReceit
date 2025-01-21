import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/step_model.dart';
import 'package:flutter_top_receit/domain/entities/steps_entity.dart';

abstract class StepsRepository {
  Future<Either<Failure, List<StepEntity>>> getStepsByRecipe(int recipeId);
  Future<Either<Failure, StepEntity>> createStep(int recipeId, StepModel step);
  Future<Either<Failure, StepEntity>> updateStep(
      int recipeId, int stepId, StepModel step);
  Future<Either<Failure, void>> deleteStep(int recipeId, int stepId);
  Future<Either<Failure, void>> deleteStepById(int stepId);
}
