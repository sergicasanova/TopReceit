import 'package:flutter_top_receit/data/models/ingredient_model.dart';

class RecipeIngredientModel {
  final int idRecipeIngredient;
  int? idRecipe;
  final int quantity;
  final String unit;
  final IngredientModel ingredient;

  RecipeIngredientModel({
    required this.idRecipeIngredient,
    this.idRecipe,
    required this.quantity,
    required this.unit,
    required this.ingredient,
  });

  factory RecipeIngredientModel.fromJson(Map<String, dynamic> json) {
    return RecipeIngredientModel(
      idRecipeIngredient: json['id_recipe_ingredient'] ?? 0,
      quantity: int.tryParse(json['quantity'].toString())!,
      unit: json['unit'] ?? '',
      ingredient: IngredientModel.fromJson(json['ingredient'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_recipe_ingredient': idRecipeIngredient,
      'recipe_id': idRecipe,
      'quantity': quantity,
      'unit': unit,
      'ingredient': ingredient.toJson(),
    };
  }

  RecipeIngredientModel copyWith({
    int? idRecipeIngredient,
    int? idRecipe,
    int? quantity,
    String? unit,
    IngredientModel? ingredient,
  }) {
    return RecipeIngredientModel(
      idRecipeIngredient: idRecipeIngredient ?? this.idRecipeIngredient,
      idRecipe: idRecipe ?? this.idRecipe,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      ingredient: ingredient ?? this.ingredient,
    );
  }
}
