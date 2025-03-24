import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/datasources/shopping_list_datasource.dart';
import 'package:flutter_top_receit/data/models/shopping_list_items.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_entity.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_item_entity.dart';
import 'package:flutter_top_receit/domain/repositories/shopping_list_repository.dart';

class ShoppingListRepositoryImpl implements ShoppingListRepository {
  final ShoppingListApiDataSource shoppingDataSource;

  ShoppingListRepositoryImpl(this.shoppingDataSource);

  @override
  Future<Either<Failure, ShoppingListEntity>> getShoppingList(
      String userId) async {
    try {
      final shoppingList = await shoppingDataSource.getShoppingList(userId);
      return Right(shoppingList.toEntity());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Error al obtener la lista de compras'));
    }
  }

  @override
  Future<Either<Failure, ShoppingListEntity>> addRecipeIngredients(
      String userId, int recipeId) async {
    try {
      final shoppingList =
          await shoppingDataSource.addRecipeIngredients(userId, recipeId);
      return Right(shoppingList.toEntity());
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al añadir ingredientes'));
    }
  }

  @override
  Future<Either<Failure, void>> removeItem(String userId, String itemId) async {
    try {
      await shoppingDataSource.removeItem(userId, itemId);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al eliminar el ítem'));
    }
  }

  @override
  Future<Either<Failure, void>> clearShoppingList(String userId) async {
    try {
      await shoppingDataSource.clearShoppingList(userId);
      return const Right(null);
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al vaciar la lista'));
    }
  }

  @override
  Future<Either<Failure, ShoppingListItemEntity>> toggleItemPurchased(
      String userId, String itemId) async {
    try {
      final item = await shoppingDataSource.toggleItemPurchased(userId, itemId);
      return Right(item.toEntity()); // Convertir modelo a entity aquí
    } on ServerFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(message: 'Error al actualizar el ítem'));
    }
  }
}
