import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/domain/entities/recipe_entity.dart';

class RecipeState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<RecipeEntity>? recipes;
  final List<RecipeEntity>? publicRecipes; // Recipes for public display
  final List<RecipeEntity>? followingRecipes; // Recipes from followed users
  final RecipeEntity? recipe;

  // Agregar los parámetros adicionales para la creación de receta
  final String? title;
  final String? description;
  final String? image;
  final String? userId;

  const RecipeState({
    this.isLoading = false,
    this.errorMessage,
    this.recipes,
    this.publicRecipes,
    this.followingRecipes,
    this.recipe,
    this.title,
    this.description,
    this.image,
    this.userId,
  });

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage ?? '',
        recipes ?? [],
        recipe ?? '',
        title ?? '',
        description ?? '',
        image ?? '',
        userId ?? ''
      ];

  RecipeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<RecipeEntity>? recipes,
    RecipeEntity? recipe,
    String? title,
    String? description,
    String? image,
    String? userId,
  }) {
    return RecipeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      recipes: recipes ?? this.recipes,
      recipe: recipe ?? this.recipe,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      userId: userId ?? this.userId,
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

  // Modificar el factory de created para usar los nuevos parámetros
  factory RecipeState.created(
          String title, String description, String image, String userId) =>
      RecipeState(
        title: title,
        description: description,
        image: image,
        userId: userId,
      );

  factory RecipeState.deleted() => const RecipeState();

  factory RecipeState.imageDeleted() => const RecipeState(); // Nuevo estado

  factory RecipeState.filtered(List<RecipeEntity> filteredRecipes) =>
      RecipeState(recipes: filteredRecipes);

  factory RecipeState.publicRecipesLoaded(List<RecipeEntity> publicRecipes) =>
      RecipeState(publicRecipes: publicRecipes);

  factory RecipeState.publicRecipesByUserLoaded(
          List<RecipeEntity> publicRecipesByUser) =>
      RecipeState(recipes: publicRecipesByUser);

  factory RecipeState.followingRecipesLoaded(
          List<RecipeEntity> followingRecipes) =>
      RecipeState(followingRecipes: followingRecipes);
}
