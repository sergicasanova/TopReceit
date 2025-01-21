import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/datasources/steps_api_datasource.dart';
import 'package:flutter_top_receit/data/models/step_model.dart';
import 'package:flutter_top_receit/domain/entities/steps_entity.dart';
import 'package:flutter_top_receit/domain/repositories/steps_repository.dart';

class StepsRepositoryImpl implements StepsRepository {
  final StepsApiDataSource stepsApiDataSource;

  StepsRepositoryImpl(this.stepsApiDataSource);

  @override
  Future<Either<Failure, List<StepEntity>>> getStepsByRecipe(
      int recipeId) async {
    try {
      final stepModels = await stepsApiDataSource.getStepsByRecipe(recipeId);
      final steps =
          stepModels.map((model) => StepEntity.fromModel(model)).toList();
      return Right(steps);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al obtener los pasos.'));
    }
  }

  @override
  Future<Either<Failure, StepEntity>> createStep(
      int recipeId, StepModel step) async {
    try {
      final stepModel = await stepsApiDataSource.createStep(recipeId, step);
      return Right(StepEntity.fromModel(stepModel));
    } catch (e) {
      return Left(ServerFailure(message: 'Error al crear el paso.'));
    }
  }

  @override
  Future<Either<Failure, StepEntity>> updateStep(
      int recipeId, int stepId, StepModel step) async {
    try {
      final stepModel =
          await stepsApiDataSource.updateStep(recipeId, stepId, step);
      return Right(StepEntity.fromModel(stepModel));
    } catch (e) {
      return Left(ServerFailure(message: 'Error al actualizar el paso.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStep(int recipeId, int stepId) async {
    try {
      await stepsApiDataSource.deleteStep(recipeId, stepId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al eliminar el paso.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStepById(int stepId) async {
    try {
      await stepsApiDataSource.deleteStepById(stepId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al eliminar el paso.'));
    }
  }
}
