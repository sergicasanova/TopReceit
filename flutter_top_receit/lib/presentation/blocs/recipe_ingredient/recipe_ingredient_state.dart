import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/domain/entities/recipe_ingredient_entity.dart';

class RecipeIngredientState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<RecipeIngredientEntity>? recipeIngredients;
  final RecipeIngredientEntity? recipeIngredient;

  const RecipeIngredientState({
    this.isLoading = false,
    this.errorMessage,
    this.recipeIngredients,
    this.recipeIngredient,
  });

  @override
  List<Object?> get props =>
      [isLoading, errorMessage, recipeIngredients, recipeIngredient];

  RecipeIngredientState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<RecipeIngredientEntity>? recipeIngredients,
    RecipeIngredientEntity? recipeIngredient,
  }) {
    return RecipeIngredientState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      recipeIngredients: recipeIngredients ?? this.recipeIngredients,
      recipeIngredient: recipeIngredient ?? this.recipeIngredient,
    );
  }

  factory RecipeIngredientState.initial() => const RecipeIngredientState();

  factory RecipeIngredientState.loading() =>
      const RecipeIngredientState(isLoading: true);

  factory RecipeIngredientState.loaded(
          List<RecipeIngredientEntity> recipeIngredients) =>
      RecipeIngredientState(recipeIngredients: recipeIngredients);

  factory RecipeIngredientState.loadedById(
          RecipeIngredientEntity recipeIngredient) =>
      RecipeIngredientState(recipeIngredient: recipeIngredient);

  factory RecipeIngredientState.created(
          RecipeIngredientEntity recipeIngredient) =>
      RecipeIngredientState(recipeIngredient: recipeIngredient);

  factory RecipeIngredientState.failure(String errorMessage) =>
      RecipeIngredientState(errorMessage: errorMessage);

  factory RecipeIngredientState.updated(
          RecipeIngredientEntity recipeIngredient) =>
      RecipeIngredientState(recipeIngredient: recipeIngredient);

  factory RecipeIngredientState.deleted() => const RecipeIngredientState();
}
