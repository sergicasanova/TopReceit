import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/domain/entities/recipe_entity.dart';

class RecipeState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<RecipeEntity>? recipes;
  final RecipeEntity? recipe;

  const RecipeState({
    this.isLoading = false,
    this.errorMessage,
    this.recipes,
    this.recipe,
  });

  @override
  List<Object?> get props =>
      [isLoading, errorMessage ?? '', recipes ?? [], recipe ?? ''];

  RecipeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<RecipeEntity>? recipes,
    RecipeEntity? recipe,
  }) {
    return RecipeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      recipes: recipes ?? this.recipes,
      recipe: recipe ?? this.recipe,
    );
  }

  factory RecipeState.initial() => const RecipeState();

  factory RecipeState.loading() => const RecipeState(isLoading: true);

  factory RecipeState.success() => const RecipeState();

  factory RecipeState.failure(String errorMessage) =>
      RecipeState(errorMessage: errorMessage);

  factory RecipeState.loaded(List<RecipeEntity> recipes) =>
      RecipeState(recipes: recipes);

  factory RecipeState.loadedRecipe(RecipeEntity recipe) =>
      RecipeState(recipe: recipe);

  factory RecipeState.loadedRecipes(List<RecipeEntity> recipes) =>
      RecipeState(recipes: recipes);

  factory RecipeState.created(RecipeEntity recipe) =>
      RecipeState(recipe: recipe);

  factory RecipeState.deleted() => const RecipeState();

  factory RecipeState.filtered(List<RecipeEntity> filteredRecipes) =>
      RecipeState(recipes: filteredRecipes);
}
