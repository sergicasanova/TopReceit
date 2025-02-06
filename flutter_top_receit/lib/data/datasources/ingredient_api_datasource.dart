import 'dart:convert';
import 'package:flutter_top_receit/config/router/api_config.dart';
import 'package:flutter_top_receit/data/models/ingredient_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_top_receit/core/failure.dart';

abstract class IngredientDataSource {
  Future<List<IngredientModel>> getAllIngredients({String? name});
  Future<IngredientModel> createIngredient(IngredientModel ingredient);
  Future<void> deleteIngredient(int id);
}

class IngredientApiDataSource implements IngredientDataSource {
  final String baseUrl = ApiConfig.baseUrl;
  final http.Client client;

  IngredientApiDataSource(this.client);

  @override
  Future<List<IngredientModel>> getAllIngredients({String? name}) async {
    final url = Uri.parse('$baseUrl/ingredient');
    final Map<String, String> queryParams = name != null ? {'name': name} : {};

    final uri = url.replace(queryParameters: queryParams);

    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData
          .map((json) => IngredientModel.fromJson(json))
          .toList();
    } else {
      throw ServerFailure(message: 'Error al obtener los ingredientes.');
    }
  }

  @override
  Future<IngredientModel> createIngredient(IngredientModel ingredient) async {
    final url = Uri.parse('$baseUrl/ingredient');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': ingredient.name,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      return IngredientModel.fromJson(responseData);
    } else {
      throw ServerFailure(message: 'Error al crear el ingrediente.');
    }
  }

  @override
  Future<void> deleteIngredient(int id) async {
    final url = Uri.parse('$baseUrl/ingredient/$id');

    final response = await client.delete(url);

    if (response.statusCode != 200) {
      throw ServerFailure(message: 'Error al eliminar el ingrediente.');
    }
  }
}
