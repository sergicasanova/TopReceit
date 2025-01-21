import 'package:flutter_top_receit/data/models/ingredient_model.dart';

class IngredientEntity {
  final int idIngredient;
  final String name;

  IngredientEntity({
    required this.idIngredient,
    required this.name,
  });

  // Constructor que acepta un IngredientModel
  factory IngredientEntity.fromModel(IngredientModel model) {
    return IngredientEntity(
      idIngredient: model.idIngredient,
      name: model.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ingredient': idIngredient,
      'name': name,
    };
  }
}
