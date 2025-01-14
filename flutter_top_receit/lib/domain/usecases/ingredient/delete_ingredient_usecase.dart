import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/ingredient_repository.dart';

class DeleteIngredientUseCase {
  final IngredientRepository repository;

  DeleteIngredientUseCase(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteIngredient(id);
  }
}
