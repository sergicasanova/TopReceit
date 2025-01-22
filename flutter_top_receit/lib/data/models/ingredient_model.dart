import 'package:flutter_top_receit/domain/entities/ingredient_entity.dart';

class IngredientModel {
  final int idIngredient;
  final String name;

  IngredientModel({required this.idIngredient, required this.name});

  factory IngredientModel.fromJson(Map<String, dynamic> json) {
    return IngredientModel(
      idIngredient: json['id_ingredient'],
      name: json['name'] ?? '',
    );
  }

  factory IngredientModel.fromEntity(IngredientEntity entity) {
    return IngredientModel(
      idIngredient: entity.idIngredient,
      name: entity.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_ingredient': idIngredient,
      'name': name,
    };
  }

  IngredientEntity toIngredientEntity() {
    return IngredientEntity(
      idIngredient: idIngredient,
      name: name,
    );
  }
}
