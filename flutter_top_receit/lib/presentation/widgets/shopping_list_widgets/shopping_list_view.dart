import 'package:flutter/material.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_item_entity.dart';
import 'package:flutter_top_receit/presentation/blocs/shopping_list/shopping_list_state.dart';
import 'shopping_list_item.dart';

class ShoppingListView extends StatelessWidget {
  final ShoppingListState state;
  final String userId;
  final Future<void> Function() onRefresh;

  const ShoppingListView({
    super.key,
    required this.state,
    required this.userId,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.errorMessage != null) {
      return Center(child: Text(state.errorMessage!));
    }

    if (state.shoppingList == null || state.shoppingList!.items.isEmpty) {
      return const Center(child: Text('La lista está vacía'));
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: state.ingredients.length,
        itemBuilder: (context, index) {
          final ingredientName = state.ingredients[index];
          final items = state.shoppingList!.items
              .where((item) => item.ingredientName == ingredientName)
              .toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  ingredientName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(height: 1, thickness: 1),
              ...items
                  .map((item) => ShoppingListItem(
                        item: item,
                        userId: userId,
                      ))
                  .toList(),
            ],
          );
        },
      ),
    );
  }
}
