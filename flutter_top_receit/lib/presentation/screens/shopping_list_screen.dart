import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/shopping_list/shopping_list_event.dart';
import 'package:flutter_top_receit/presentation/blocs/shopping_list/shopping_list_state.dart';
import 'package:flutter_top_receit/presentation/widgets/shopping_list_widgets/shopping_list_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_top_receit/presentation/blocs/shopping_list/shopping_list_bloc.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserIdAndShoppingList();
  }

  Future<void> _loadCurrentUserIdAndShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('id');
    });

    if (currentUserId != null) {
      context
          .read<ShoppingListBloc>()
          .add(GetShoppingListEvent(userId: currentUserId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compra'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: currentUserId != null
                ? () => _clearList(context, currentUserId!)
                : null,
          ),
        ],
      ),
      body: BlocBuilder<ShoppingListBloc, ShoppingListState>(
        builder: (context, state) {
          if (currentUserId == null) {
            return const Center(child: Text('Usuario no identificado'));
          }

          return ShoppingListView(
            state: state,
            userId: currentUserId!,
            onRefresh: () => _refreshList(currentUserId!),
          );
        },
      ),
    );
  }

  Future<void> _refreshList(String userId) async {
    context.read<ShoppingListBloc>().add(GetShoppingListEvent(userId: userId));
  }

  Future<void> _clearList(BuildContext context, String userId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vaciar lista'),
        content: const Text('¿Eliminar todos los ingredientes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Vaciar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      context
          .read<ShoppingListBloc>()
          .add(ClearShoppingListEvent(userId: userId));
    }
  }
}
