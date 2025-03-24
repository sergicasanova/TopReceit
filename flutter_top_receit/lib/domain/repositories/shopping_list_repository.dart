import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_entity.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_item_entity.dart';

abstract class ShoppingListRepository {
  // Obtiene la lista de compras completa de un usuario
  Future<Either<Failure, ShoppingListEntity>> getShoppingList(String userId);

  // Añade ingredientes de una receta a la lista
  Future<Either<Failure, ShoppingListEntity>> addRecipeIngredients(
      String userId, int recipeId);

  // Elimina un ítem específico de la lista
  Future<Either<Failure, void>> removeItem(String userId, String itemId);

  // Vacía toda la lista de compras
  Future<Either<Failure, void>> clearShoppingList(String userId);

  // Cambia el estado de comprado de un ítem (toggle)
  Future<Either<Failure, ShoppingListItemEntity>> toggleItemPurchased(
      String userId, String itemId);
}
