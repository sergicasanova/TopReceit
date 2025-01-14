import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/ingredient_model.dart';
import 'package:flutter_top_receit/domain/repositories/ingredient_repository.dart';

class CreateIngredientUseCase {
  final IngredientRepository repository;

  CreateIngredientUseCase(this.repository);

  Future<Either<Failure, IngredientModel>> call(IngredientModel ingredient) {
    return repository.createIngredient(ingredient);
  }
}
