import 'package:flutter_top_receit/data/models/shopping_list_items.dart';

class ShoppingList {
  final String id;
  final String? name;
  final List<ShoppingListItem> items;

  ShoppingList({
    required this.id,
    this.name,
    required this.items,
  });

  factory ShoppingList.fromJson(Map<String, dynamic> json) {
    return ShoppingList(
      id: json['id'] ?? '',
      name: json['name'],
      items: (json['items'] as List<dynamic>)
          .map((item) => ShoppingListItem.fromJson(item))
          .toList(),
    );
  }
}
