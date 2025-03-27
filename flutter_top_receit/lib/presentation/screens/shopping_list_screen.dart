import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/shopping_list/shopping_list_event.dart';
import 'package:flutter_top_receit/presentation/blocs/shopping_list/shopping_list_state.dart';
import 'package:flutter_top_receit/presentation/widgets/shopping_list_widgets/shopping_list_view.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_top_receit/presentation/blocs/shopping_list/shopping_list_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  String? currentUserId;
  int _selectedIndex = 0;
  final List<String> _routes = [
    '/home',
    '/allRecipes',
    '/shopping-list',
  ];

  @override
  void initState() {
    super.initState();
    _loadCurrentUserIdAndShoppingList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    GoRouter.of(context).go(_routes[index]);
  }

  Future<void> _loadCurrentUserIdAndShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('id');
    });

    if (currentUserId != null) {
      // ignore: use_build_context_synchronously
      context
          .read<ShoppingListBloc>()
          .add(GetShoppingListEvent(userId: currentUserId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.shopping_list_label),
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
            return Center(
                child: Text(AppLocalizations.of(context)!.unidentified_user));
          }

          return ShoppingListView(
            state: state,
            userId: currentUserId!,
            onRefresh: () => _refreshList(currentUserId!),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home_label),
          BottomNavigationBarItem(
              icon: const Icon(Icons.public),
              label: AppLocalizations.of(context)!.public_recipes_label),
          BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart),
              label: AppLocalizations.of(context)!.shopping_list_label),
        ],
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
        title: Text(AppLocalizations.of(context)!.empty_list),
        content: Text(
            AppLocalizations.of(context)!.delete_all_ingredients_confirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(AppLocalizations.of(context)!.cancel_button),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.empty_list,
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // ignore: use_build_context_synchronously
      context
          .read<ShoppingListBloc>()
          .add(ClearShoppingListEvent(userId: userId));
    }
  }
}
