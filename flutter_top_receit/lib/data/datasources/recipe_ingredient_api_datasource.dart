import 'dart:convert';
import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class RecipeIngredientDataSource {
  Future<RecipeIngredientModel> createRecipeIngredient(
      RecipeIngredientModel recipeIngredient);
  Future<List<RecipeIngredientModel>> getAllIngredientsForRecipe(int recipeId);
  Future<RecipeIngredientModel> getIngredientById(int idRecipeIngredient);
  Future<RecipeIngredientModel> updateRecipeIngredient(
      RecipeIngredientModel recipeIngredient,
      int recipeId,
      int idRecipeIngredient);
  Future<void> deleteRecipeIngredient(int recipeId, int idRecipeIngredient);
}

class RecipeIngredientApiDataSource implements RecipeIngredientDataSource {
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000';
  final http.Client client;

  RecipeIngredientApiDataSource(this.client);

  @override
  Future<RecipeIngredientModel> createRecipeIngredient(
      RecipeIngredientModel recipeIngredient) async {
    final url = Uri.parse('$baseUrl/recipe-ingredients');

    final recipeIngredientMap = {
      'recipe_id': recipeIngredient.idRecipe,
      'ingredient_id': recipeIngredient.ingredient.idIngredient,
      'quantity': recipeIngredient.quantity,
      'unit': recipeIngredient.unit,
    };

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(recipeIngredientMap),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return RecipeIngredientModel.fromJson(responseData);
    } else {
      throw ServerFailure(
          message: 'Error al crear el ingrediente en la receta.');
    }
  }

  @override
  Future<List<RecipeIngredientModel>> getAllIngredientsForRecipe(
      int recipeId) async {
    final url = Uri.parse('$baseUrl/recipe-ingredients/recipe/$recipeId');

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData
          .map((data) => RecipeIngredientModel.fromJson(data))
          .toList();
    } else {
      throw ServerFailure(
          message: 'Error al obtener los ingredientes de la receta.');
    }
  }

  @override
  Future<RecipeIngredientModel> getIngredientById(
      int idRecipeIngredient) async {
    final url = Uri.parse('$baseUrl/recipe-ingredients/$idRecipeIngredient');

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return RecipeIngredientModel.fromJson(responseData);
    } else {
      throw ServerFailure(
          message: 'Error al obtener el ingrediente de la receta.');
    }
  }

  @override
  Future<RecipeIngredientModel> updateRecipeIngredient(
      RecipeIngredientModel recipeIngredient,
      int recipeId,
      int idRecipeIngredient) async {
    final url =
        Uri.parse('$baseUrl/recipe-ingredients/$recipeId/$idRecipeIngredient');

    final response = await client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'ingredient_id': recipeIngredient.ingredient,
        'quantity': recipeIngredient.quantity,
        'unit': recipeIngredient.unit,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return RecipeIngredientModel.fromJson(responseData);
    } else {
      throw ServerFailure(
          message: 'Error al actualizar el ingrediente en la receta.');
    }
  }

  @override
  Future<void> deleteRecipeIngredient(
      int recipeId, int idRecipeIngredient) async {
    final url =
        Uri.parse('$baseUrl/recipe-ingredients/$recipeId/$idRecipeIngredient');

    final response = await client.delete(url);

    if (response.statusCode != 200) {
      throw ServerFailure(
          message: 'Error al eliminar el ingrediente de la receta.');
    }
  }
}
