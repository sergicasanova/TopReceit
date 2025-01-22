import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';
import 'package:flutter_top_receit/domain/entities/ingredient_entity.dart';

class RecipeIngredientEntity {
  int idRecipeIngredient;
  final int quantity;
  final String unit;
  final IngredientEntity ingredient;

  RecipeIngredientEntity({
    required this.idRecipeIngredient,
    required this.quantity,
    required this.unit,
    required this.ingredient,
  });

  factory RecipeIngredientEntity.fromModel(RecipeIngredientModel model) {
    return RecipeIngredientEntity(
      idRecipeIngredient: model.idRecipeIngredient!,
      quantity: model.quantity,
      unit: model.unit,
      ingredient: IngredientEntity.fromModel(model.ingredient),
    );
  }
}
