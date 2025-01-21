import 'package:flutter_top_receit/data/models/recipe_model.dart';
import 'package:flutter_top_receit/domain/entities/recipe_ingredient_entity.dart';
import 'package:flutter_top_receit/domain/entities/steps_entity.dart';

class RecipeEntity {
  int? idRecipe;
  final String? title;
  final String? description;
  final String? image;
  String? userId;
  final List<RecipeIngredientEntity> recipeIngredients;
  final List<StepEntity> steps;

  RecipeEntity({
    this.idRecipe,
    this.title,
    this.description,
    this.image,
    this.userId,
    required this.recipeIngredients,
    required this.steps,
  });

  factory RecipeEntity.fromModel(RecipeModel model) {
    return RecipeEntity(
      idRecipe: model.idRecipe,
      title: model.title,
      description: model.description,
      image: model.image,
      userId: model.userId,
      recipeIngredients: model.recipeIngredients
          .map((ingredientModel) =>
              RecipeIngredientEntity.fromModel(ingredientModel))
          .toList(),
      steps: model.steps
          .map((stepModel) => StepEntity.fromModel(stepModel))
          .toList(),
    );
  }
}
