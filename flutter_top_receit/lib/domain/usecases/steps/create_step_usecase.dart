import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/step_model.dart';
import 'package:flutter_top_receit/domain/entities/steps_entity.dart';
import 'package:flutter_top_receit/domain/repositories/steps_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class CreateStepUseCase
    implements UseCase<Either<Failure, StepEntity>, StepModel> {
  final StepsRepository repository;

  CreateStepUseCase(this.repository);

  @override
  Future<Either<Failure, StepEntity>> call(StepModel step) async {
    return repository.createStep(step.idRecipe!, step);
  }
}
