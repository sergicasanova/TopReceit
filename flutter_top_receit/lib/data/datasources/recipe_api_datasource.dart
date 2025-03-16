import 'dart:convert';
import 'package:flutter_top_receit/config/router/api_config.dart';
import 'package:flutter_top_receit/data/models/recipe_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_top_receit/core/failure.dart';

abstract class RecipeDataSource {
  Future<void> createRecipe(
      String title, String description, String image, String userId);
  Future<List<RecipeModel>> getAllRecipes();
  Future<RecipeModel> getRecipeById(int recipeId);
  Future<List<RecipeModel>> getRecipesByUserId(String userId);
  Future<bool> updateRecipe(UpdateRecipeDto recipe);
  Future<void> deleteRecipe(int recipeId);
  Future<List<RecipeModel>> getPublicRecipes();
  Future<List<RecipeModel>> getPublicRecipesByUserId(String userId);
}

class RecipeApiDataSource implements RecipeDataSource {
  final String baseUrl = ApiConfig.baseUrl;
  final http.Client client;

  RecipeApiDataSource(this.client);

  @override
  Future<void> createRecipe(
      String title, String description, String image, String userId) async {
    var request = http.Request(
      'POST',
      Uri.parse('$baseUrl/recipe'),
    );
    request.headers.addAll({
      'Content-Type': 'application/json',
    });

    final recipeData = {
      'title': title,
      'description': description,
      'user_id': userId,
      'image': image,
    };

    request.body = json.encode(recipeData);
    var response = await request.send();

    if (response.statusCode != 201) {
      throw Exception('Error al crear la receta: ${response.statusCode}');
    }
  }

  @override
  Future<List<RecipeModel>> getAllRecipes() async {
    final url = Uri.parse('$baseUrl/recipe');

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      return responseData.map((data) => RecipeModel.fromJson(data)).toList();
    } else {
      throw ServerFailure(message: 'Error al obtener todas las recetas');
    }
  }

  @override
  Future<RecipeModel> getRecipeById(int recipeId) async {
    final url = Uri.parse('$baseUrl/recipe/$recipeId');

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData is Map<String, dynamic>) {
        return RecipeModel.fromJson(responseData);
      } else {
        throw ServerFailure(message: 'Datos de receta incorrectos.');
      }
    } else {
      throw ServerFailure(message: 'Error al obtener la receta');
    }
  }

  @override
  Future<List<RecipeModel>> getRecipesByUserId(String userId) async {
    final url = Uri.parse('$baseUrl/recipe/user/$userId');
    final response = await client.get(url);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;

      return responseData.map((data) {
        try {
          return RecipeModel.fromJson(data);
        } catch (e) {
          rethrow;
        }
      }).toList();
    } else {
      throw ServerFailure(message: 'Error al obtener las recetas del usuario');
    }
  }

  @override
  Future<bool> updateRecipe(UpdateRecipeDto dto) async {
    final url = Uri.parse('$baseUrl/recipe/${dto.idRecipe}');

    print('UpdateRecipeDto: ${dto.toJson()}');

    final response = await client.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(dto.toJson()),
    );
    print('updateRecipe' + response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      throw ServerFailure(message: 'Error al actualizar la receta.');
    }
  }

  @override
  Future<void> deleteRecipe(int recipeId) async {
    final url = Uri.parse('$baseUrl/recipe/$recipeId');

    final response = await client.delete(url);

    if (response.statusCode != 200) {
      throw ServerFailure(message: 'Error al eliminar la receta');
    }
  }

  @override
  Future<List<RecipeModel>> getPublicRecipes() async {
    final url = Uri.parse('$baseUrl/recipe/public');

    final response = await client.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;

      return responseData.map((data) => RecipeModel.fromJson(data)).toList();
    } else {
      throw ServerFailure(message: 'Error al obtener las recetas públicas');
    }
  }

  @override
  Future<List<RecipeModel>> getPublicRecipesByUserId(String userId) async {
    final url = Uri.parse('$baseUrl/user/$userId/public');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;

      return responseData.map((data) {
        try {
          return RecipeModel.fromJson(data);
        } catch (e) {
          throw ServerFailure(
              message: 'Error al convertir los datos de la receta.');
        }
      }).toList();
    } else if (response.statusCode == 404) {
      throw ServerFailure(
          message: 'Usuario no encontrado o no tiene recetas públicas.');
    } else {
      throw ServerFailure(
          message: 'Error al obtener las recetas públicas del usuario.');
    }
  }
}
