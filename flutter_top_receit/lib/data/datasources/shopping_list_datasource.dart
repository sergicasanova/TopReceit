import 'dart:convert';
import 'package:flutter_top_receit/config/router/api_config.dart';
import 'package:flutter_top_receit/data/models/shopping_list.dart';
import 'package:flutter_top_receit/data/models/shopping_list_items.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_top_receit/core/failure.dart';

abstract class ShoppingListDataSource {
  Future<ShoppingList> getShoppingList(String userId);
  Future<ShoppingList> addRecipeIngredients(String userId, int recipeId);
  Future<void> removeItem(String userId, String itemId);
  Future<void> clearShoppingList(String userId);
  Future<ShoppingListItem> toggleItemPurchased(String userId, String itemId);
}

class ShoppingListApiDataSource implements ShoppingListDataSource {
  final String baseUrl = ApiConfig.baseUrl;
  final http.Client client;

  ShoppingListApiDataSource(this.client);

  @override
  Future<ShoppingList> getShoppingList(String userId) async {
    final url = Uri.parse('$baseUrl/shopping-lists/get-shopping-list/$userId');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      return ShoppingList.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw ServerFailure(
          message: 'No se encontró una lista de la compra activa');
    } else {
      throw ServerFailure(
          message:
              'Error al obtener la lista de compras: ${response.statusCode}');
    }
  }

  @override
  Future<ShoppingList> addRecipeIngredients(String userId, int recipeId) async {
    final url = Uri.parse(
        '$baseUrl/shopping-lists/add-recipe-ingredients/$userId/$recipeId');
    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ShoppingList.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw ServerFailure(message: 'Usuario o receta no encontrados');
    } else {
      throw ServerFailure(
          message: 'Error al añadir ingredientes: ${response.statusCode}');
    }
  }

  @override
  Future<void> removeItem(String userId, String itemId) async {
    final url =
        Uri.parse('$baseUrl/shopping-lists/remove-item/$userId/$itemId');
    final response = await client.delete(url);

    if (response.statusCode != 200) {
      throw ServerFailure(
          message: 'Error al eliminar el ítem: ${response.statusCode}');
    }
  }

  @override
  Future<void> clearShoppingList(String userId) async {
    final url =
        Uri.parse('$baseUrl/shopping-lists/clear-shopping-list/$userId');
    final response = await client.delete(url);

    if (response.statusCode != 200) {
      throw ServerFailure(
          message: 'Error al vaciar la lista: ${response.statusCode}');
    }
  }

  @override
  Future<ShoppingListItem> toggleItemPurchased(
      String userId, String itemId) async {
    final url = Uri.parse(
        '$baseUrl/shopping-lists/toggle-item-purchased/$userId/$itemId');
    final response = await client.patch(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return ShoppingListItem.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw ServerFailure(
          message: 'Ítem no encontrado en la lista de la compra');
    } else {
      throw ServerFailure(
          message: 'Error al actualizar el ítem: ${response.statusCode}');
    }
  }
}
