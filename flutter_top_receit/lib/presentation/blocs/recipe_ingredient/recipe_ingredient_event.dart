// recipe_ingredient_event.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';

abstract class RecipeIngredientEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllIngredientsForRecipeEvent extends RecipeIngredientEvent {
  final int recipeId;

  GetAllIngredientsForRecipeEvent({required this.recipeId});

  @override
  List<Object?> get props => [recipeId];
}

class GetIngredientByIdEvent extends RecipeIngredientEvent {
  final int idRecipeIngredient;

  GetIngredientByIdEvent({required this.idRecipeIngredient});

  @override
  List<Object?> get props => [idRecipeIngredient];
}

class CreateRecipeIngredientEvent extends RecipeIngredientEvent {
  final RecipeIngredientModel recipeIngredient;

  CreateRecipeIngredientEvent({required this.recipeIngredient});

  @override
  List<Object?> get props => [recipeIngredient];
}

class UpdateRecipeIngredientEvent extends RecipeIngredientEvent {
  final RecipeIngredientModel recipeIngredient;
  final int recipeId;
  final int idRecipeIngredient;

  UpdateRecipeIngredientEvent({
    required this.recipeIngredient,
    required this.recipeId,
    required this.idRecipeIngredient,
  });

  @override
  List<Object?> get props => [recipeIngredient, recipeId, idRecipeIngredient];
}

class DeleteRecipeIngredientEvent extends RecipeIngredientEvent {
  final int recipeId;
  final int idRecipeIngredient;

  DeleteRecipeIngredientEvent(
      {required this.recipeId, required this.idRecipeIngredient});

  @override
  List<Object?> get props => [recipeId, idRecipeIngredient];
}
