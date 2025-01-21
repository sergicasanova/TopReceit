import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/steps_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class DeleteStepByIdUseCase implements UseCase<Either<Failure, void>, int> {
  final StepsRepository repository;

  DeleteStepByIdUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int stepId) async {
    return repository.deleteStepById(stepId);
  }
}
