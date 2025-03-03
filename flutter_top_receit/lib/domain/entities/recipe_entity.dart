import 'package:flutter_top_receit/data/models/recipe_model.dart';
import 'package:flutter_top_receit/domain/entities/recipe_ingredient_entity.dart';
import 'package:flutter_top_receit/domain/entities/steps_entity.dart';
import 'package:flutter_top_receit/domain/entities/user_entity.dart';

class RecipeEntity {
  int? idRecipe;
  final String? title;
  final String? description;
  final String? image;
  final bool? isPublic;
  UserEntity? user;
  final List<RecipeIngredientEntity> recipeIngredients;
  final List<StepEntity> steps;
  final List<String>? likeUserIds;

  RecipeEntity({
    this.idRecipe,
    this.title,
    this.description,
    this.image,
    this.isPublic,
    this.user,
    required this.recipeIngredients,
    required this.steps,
    this.likeUserIds,
  });

  factory RecipeEntity.fromModel(RecipeModel model) {
    return RecipeEntity(
      idRecipe: model.idRecipe,
      title: model.title,
      description: model.description,
      image: model.image,
      isPublic: model.isPublic,
      user: model.user != null ? UserEntity.fromModel(model.user!) : null,
      recipeIngredients: model.recipeIngredients
          .map((ingredientModel) =>
              RecipeIngredientEntity.fromModel(ingredientModel))
          .toList(),
      steps: model.steps
          .map((stepModel) => StepEntity.fromModel(stepModel))
          .toList(),
      likeUserIds: model.likeUserIds,
    );
  }
}
