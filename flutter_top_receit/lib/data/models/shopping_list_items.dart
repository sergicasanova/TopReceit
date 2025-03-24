import 'package:flutter_top_receit/domain/entities/shopping_list_item_entity.dart';

class ShoppingListItem {
  final String id;
  final String ingredientName;
  final double quantity;
  final String unit;
  final bool isPurchased;

  ShoppingListItem({
    required this.id,
    required this.ingredientName,
    required this.quantity,
    required this.unit,
    required this.isPurchased,
  });

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) {
    return ShoppingListItem(
      id: json['id'] ?? '',
      ingredientName: json['ingredientName'] ?? '',
      quantity: json['quantity']?.toDouble() ?? 0.0,
      unit: json['unit'] ?? '',
      isPurchased: json['isPurchased'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ingredientName': ingredientName,
      'quantity': quantity,
      'unit': unit,
      'isPurchased': isPurchased,
    };
  }

  ShoppingListItem copyWith({
    String? id,
    String? ingredientName,
    double? quantity,
    String? unit,
    bool? isPurchased,
  }) {
    return ShoppingListItem(
      id: id ?? this.id,
      ingredientName: ingredientName ?? this.ingredientName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }

  ShoppingListItemEntity toEntity() {
    return ShoppingListItemEntity(
      id: id,
      ingredientName: ingredientName,
      quantity: quantity,
      unit: unit,
      isPurchased: isPurchased,
    );
  }
}
