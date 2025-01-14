import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/ingredient_model.dart';
import 'package:flutter_top_receit/domain/entities/ingredient_entity.dart';

abstract class IngredientRepository {
  Future<Either<Failure, List<IngredientEntity>>> getAllIngredients(
      {String? name});
  Future<Either<Failure, IngredientModel>> createIngredient(
      IngredientModel ingredient);
  Future<Either<Failure, void>> deleteIngredient(int id);
}
