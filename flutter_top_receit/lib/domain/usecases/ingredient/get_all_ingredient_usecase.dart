import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/ingredient_entity.dart';
import 'package:flutter_top_receit/domain/repositories/ingredient_repository.dart';

class GetAllIngredientsUseCase {
  final IngredientRepository repository;

  GetAllIngredientsUseCase(this.repository);

  Future<Either<Failure, List<IngredientEntity>>> call({String? name}) {
    return repository.getAllIngredients(name: name);
  }
}
