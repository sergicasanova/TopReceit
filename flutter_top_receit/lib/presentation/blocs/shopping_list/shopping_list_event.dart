import 'package:equatable/equatable.dart';

abstract class ShoppingListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetShoppingListEvent extends ShoppingListEvent {
  final String userId;

  GetShoppingListEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class AddRecipeIngredientsEvent extends ShoppingListEvent {
  final String userId;
  final int recipeId;

  AddRecipeIngredientsEvent({required this.userId, required this.recipeId});

  @override
  List<Object?> get props => [userId, recipeId];
}

class RemoveItemEvent extends ShoppingListEvent {
  final String userId;
  final String itemId;

  RemoveItemEvent({required this.userId, required this.itemId});

  @override
  List<Object?> get props => [userId, itemId];
}

class ClearShoppingListEvent extends ShoppingListEvent {
  final String userId;

  ClearShoppingListEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ToggleItemPurchasedEvent extends ShoppingListEvent {
  final String userId;
  final String itemId;

  ToggleItemPurchasedEvent({required this.userId, required this.itemId});

  @override
  List<Object?> get props => [userId, itemId];
}
