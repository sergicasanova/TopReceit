import 'dart:convert';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class LikeDataSource {
  Future<void> giveLike(String userId, int recipeId);
  Future<void> removeLike(String userId, int recipeId);
  Future<List<String>> getLikesByRecipeId(int recipeId);
}

class LikeApiDataSource implements LikeDataSource {
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000';
  final http.Client client;

  LikeApiDataSource(this.client);

  @override
  Future<void> giveLike(String userId, int recipeId) async {
    final url = Uri.parse('$baseUrl/likes');

    try {
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'recipeId': recipeId,
        }),
      );

      if (response.statusCode != 201) {
        throw ServerFailure(message: 'Error al dar like a la receta');
      }
    } on Exception catch (e) {
      throw ServerFailure(message: 'Error al dar like a la receta');
    }
  }

  @override
  Future<void> removeLike(String userId, int recipeId) async {
    final url = Uri.parse('$baseUrl/likes');

    final response = await client.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': userId,
        'recipeId': recipeId,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerFailure(message: 'Error al quitar like de la receta');
    }
  }

  @override
  Future<List<String>> getLikesByRecipeId(int recipeId) async {
    final url = Uri.parse('$baseUrl/likes/$recipeId/users');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      print("Likes received: $responseData");
      return List<String>.from(responseData);
    } else {
      throw ServerFailure(message: 'Error al obtener los likes de la receta');
    }
  }
}
