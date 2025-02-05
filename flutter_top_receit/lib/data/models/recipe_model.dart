import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';
import 'package:flutter_top_receit/data/models/step_model.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/entities/recipe_entity.dart';

class RecipeModel {
  int? idRecipe;
  final String? title;
  final String? description;
  String? image;
  UserModel? user;
  final List<RecipeIngredientModel> recipeIngredients;
  final List<StepModel> steps;
  final List<String>? likeUserIds;

  RecipeModel({
    this.idRecipe,
    this.title,
    this.description,
    this.image,
    this.user,
    required this.recipeIngredients,
    required this.steps,
    this.likeUserIds,
  });

  RecipeEntity toRecipeEntity() {
    return RecipeEntity.fromModel(this);
  }

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      idRecipe: json['id_recipe'],
      title: json['title'],
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      recipeIngredients: (json['recipeIngredients'] as List?)
              ?.map((e) => RecipeIngredientModel.fromJson(e))
              .toList() ??
          [],
      steps: (json['steps'] as List?)
              ?.map((e) => StepModel.fromJson(e))
              .toList() ??
          [],
      likeUserIds: (json['likes'] as List?)
          ?.map((e) => e['user']['id_user'] as String)
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'user': user?.toJson(),
      'recipeIngredients': recipeIngredients.map((e) => e.toJson()).toList(),
      'steps': steps.map((e) => e.toJson()).toList(),
    };
  }

  RecipeModel copyWith({
    int? idRecipe,
    String? title,
    String? description,
    String? image,
    List<RecipeIngredientModel>? recipeIngredients,
    List<StepModel>? steps,
  }) {
    return RecipeModel(
      idRecipe: idRecipe ?? this.idRecipe,
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      recipeIngredients: recipeIngredients ?? this.recipeIngredients,
      steps: steps ?? this.steps,
    );
  }
}

class UpdateRecipeDto {
  final int? idRecipe;
  final String? title;
  final String? description;
  final String? image;

  UpdateRecipeDto({
    this.idRecipe,
    this.title,
    this.description,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_recipe': idRecipe,
      'title': title,
      'description': description,
      'image': image,
    };
  }
}
