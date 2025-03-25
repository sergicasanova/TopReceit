import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_entity.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_item_entity.dart';

class ShoppingListState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final ShoppingListEntity? shoppingList;
  final List<String> ingredients;
  final ShoppingListItemEntity? updatedItem;

  const ShoppingListState({
    this.isLoading = false,
    this.errorMessage,
    this.shoppingList,
    this.updatedItem,
    this.ingredients = const [],
  });

  @override
  List<Object?> get props =>
      [isLoading, errorMessage, shoppingList, updatedItem, ingredients];

  ShoppingListState copyWith({
    bool? isLoading,
    String? errorMessage,
    ShoppingListEntity? shoppingList,
    ShoppingListItemEntity? updatedItem,
  }) {
    return ShoppingListState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      shoppingList: shoppingList ?? this.shoppingList,
      updatedItem: updatedItem ?? this.updatedItem,
    );
  }

  factory ShoppingListState.initial() => const ShoppingListState();

  factory ShoppingListState.loading() =>
      const ShoppingListState(isLoading: true);

  factory ShoppingListState.success() => const ShoppingListState();

  factory ShoppingListState.failure(String errorMessage) =>
      ShoppingListState(errorMessage: errorMessage);

  factory ShoppingListState.loaded(
          ShoppingListEntity shoppingList, List<String> ingredients) =>
      ShoppingListState(shoppingList: shoppingList, ingredients: ingredients);

  factory ShoppingListState.itemUpdated(ShoppingListItemEntity item) =>
      ShoppingListState(updatedItem: item);

  factory ShoppingListState.cleared() => const ShoppingListState();
}
