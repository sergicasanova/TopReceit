import 'package:flutter_top_receit/data/models/shopping_list_items.dart';

class ShoppingListItemEntity {
  final String id;
  final String ingredientName;
  final double quantity;
  final String unit;
  final bool isPurchased;

  ShoppingListItemEntity({
    required this.id,
    required this.ingredientName,
    required this.quantity,
    required this.unit,
    required this.isPurchased,
  });

  factory ShoppingListItemEntity.fromModel(ShoppingListItem model) {
    return ShoppingListItemEntity(
      id: model.id,
      ingredientName: model.ingredientName,
      quantity: model.quantity,
      unit: model.unit,
      isPurchased: model.isPurchased,
    );
  }
}
