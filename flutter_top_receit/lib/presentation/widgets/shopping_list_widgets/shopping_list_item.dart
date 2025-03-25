import 'package:flutter/material.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_item_entity.dart';
import 'shopping_list_actions.dart';

class ShoppingListItem extends StatelessWidget {
  final ShoppingListItemEntity item;
  final String userId;

  const ShoppingListItem({
    super.key,
    required this.item,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${item.quantity} ${item.unit}',
              style: const TextStyle(fontSize: 14),
            ),
          ),
          ShoppingListActions(item: item, userId: userId),
        ],
      ),
    );
  }
}
