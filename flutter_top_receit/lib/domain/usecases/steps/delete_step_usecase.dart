import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/steps_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class DeleteStepUseCase
    implements UseCase<Either<Failure, void>, DeleteStepParams> {
  final StepsRepository repository;

  DeleteStepUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteStepParams params) async {
    return repository.deleteStep(params.recipeId, params.stepId);
  }
}

class DeleteStepParams {
  final int recipeId;
  final int stepId;

  DeleteStepParams({required this.recipeId, required this.stepId});
}
