import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/datasources/ingredient_api_datasource.dart';
import 'package:flutter_top_receit/data/models/ingredient_model.dart';
import 'package:flutter_top_receit/domain/entities/ingredient_entity.dart';
import 'package:flutter_top_receit/domain/repositories/ingredient_repository.dart';

class IngredientRepositoryImpl implements IngredientRepository {
  final IngredientApiDataSource ingredientApiDataSource;

  IngredientRepositoryImpl(this.ingredientApiDataSource);

  @override
  Future<Either<Failure, List<IngredientEntity>>> getAllIngredients(
      {String? name}) async {
    try {
      final ingredientModels =
          await ingredientApiDataSource.getAllIngredients(name: name);
      final ingredients =
          ingredientModels.map((model) => model.toIngredientEntity()).toList();
      return Right(ingredients);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al obtener los ingredientes.'));
    }
  }

  @override
  Future<Either<Failure, IngredientModel>> createIngredient(
      IngredientModel ingredient) async {
    try {
      final newIngredient =
          await ingredientApiDataSource.createIngredient(ingredient);
      return Right(newIngredient);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al crear el ingrediente.'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteIngredient(int id) async {
    try {
      await ingredientApiDataSource.deleteIngredient(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al eliminar el ingrediente.'));
    }
  }
}
