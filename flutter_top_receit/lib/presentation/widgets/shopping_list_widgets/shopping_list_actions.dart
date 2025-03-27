import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_item_entity.dart';
import 'package:flutter_top_receit/presentation/blocs/shopping_list/shopping_list_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/shopping_list/shopping_list_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppingListActions extends StatelessWidget {
  final ShoppingListItemEntity item;
  final String userId;

  const ShoppingListActions({
    super.key,
    required this.item,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            item.isPurchased ? Icons.check_box : Icons.check_box_outline_blank,
            color: item.isPurchased ? Colors.green : Colors.grey,
          ),
          onPressed: () => _togglePurchased(context),
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _confirmDelete(context),
        ),
      ],
    );
  }

  void _togglePurchased(BuildContext context) {
    context.read<ShoppingListBloc>().add(
          ToggleItemPurchasedEvent(
            userId: userId,
            itemId: item.id,
          ),
        );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.delete_ingredient),
        content: Text(
            '¿${AppLocalizations.of(context)!.delete_button} ${item.ingredientName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel_button),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.delete_button,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      context.read<ShoppingListBloc>().add(
            RemoveItemEvent(
              userId: userId,
              itemId: item.id,
            ),
          );
    }
  }
}
