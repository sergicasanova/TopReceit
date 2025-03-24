import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_entity.dart';
import 'package:flutter_top_receit/domain/repositories/shopping_list_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class AddRecipeIngredientsUseCase
    implements
        UseCase<Either<Failure, ShoppingListEntity>, AddIngredientsParams> {
  final ShoppingListRepository repository;

  AddRecipeIngredientsUseCase(this.repository);

  @override
  Future<Either<Failure, ShoppingListEntity>> call(
      AddIngredientsParams params) async {
    return repository.addRecipeIngredients(params.userId, params.recipeId);
  }
}

class AddIngredientsParams {
  final String userId;
  final int recipeId;

  AddIngredientsParams({required this.userId, required this.recipeId});
}
