import 'package:flutter_top_receit/data/models/shopping_list.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_item_entity.dart';

class ShoppingListEntity {
  final String id;
  final String? name;
  final List<ShoppingListItemEntity> items;

  ShoppingListEntity({
    required this.id,
    this.name,
    required this.items,
  });

  factory ShoppingListEntity.fromModel(ShoppingList model) {
    return ShoppingListEntity(
      id: model.id,
      name: model.name,
      items: model.items
          .map((item) => ShoppingListItemEntity.fromModel(item))
          .toList(),
    );
  }
}
