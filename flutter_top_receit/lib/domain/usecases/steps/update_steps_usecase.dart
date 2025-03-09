import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/step_model.dart';
import 'package:flutter_top_receit/domain/entities/steps_entity.dart';
import 'package:flutter_top_receit/domain/repositories/steps_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class UpdateStepUseCase
    implements UseCase<Either<Failure, StepEntity>, UpdateStepParams> {
  final StepsRepository repository;

  UpdateStepUseCase(this.repository);

  @override
  Future<Either<Failure, StepEntity>> call(UpdateStepParams params) async {
    return repository.updateStep(params.stepId, params.step);
  }
}

class UpdateStepParams {
  final int stepId;
  final StepModel step;

  UpdateStepParams({required this.stepId, required this.step});
}
