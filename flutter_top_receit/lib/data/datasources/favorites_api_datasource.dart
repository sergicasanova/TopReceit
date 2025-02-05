import 'dart:convert';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class FavoriteDataSource {
  Future<void> addFavorite(String userId, int recipeId);
  Future<void> removeFavorite(String userId, int recipeId);
  Future<List<int>> getFavoritesByUserId(String userId);
}

class FavoriteApiDataSource implements FavoriteDataSource {
  final String baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:3000';
  final http.Client client;

  FavoriteApiDataSource(this.client);

  @override
  Future<void> addFavorite(String userId, int recipeId) async {
    final url = Uri.parse('$baseUrl/favorites');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'recipe_id': recipeId,
      }),
    );

    if (response.statusCode != 201) {
      throw ServerFailure(message: 'Error al agregar la receta a favoritos');
    }
  }

  @override
  Future<void> removeFavorite(String userId, int recipeId) async {
    final url = Uri.parse('$baseUrl/favorites');

    final response = await client.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'user_id': userId,
        'recipe_id': recipeId,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerFailure(message: 'Error al eliminar la receta de favoritos');
    }
  }

  @override
  Future<List<int>> getFavoritesByUserId(String userId) async {
    final url = Uri.parse('$baseUrl/favorites/$userId');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;
      return responseData.map<int>((data) => data as int).toList();
    } else {
      throw ServerFailure(
          message: 'Error al obtener los favoritos del usuario');
    }
  }
}
