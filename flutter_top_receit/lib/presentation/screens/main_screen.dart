import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/config/router/routes.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_top_receit/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/favorites/favorites_event.dart';
import 'package:flutter_top_receit/presentation/blocs/follows/follows_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/follows/follows_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/shopping_list/shopping_list_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/shopping_list/shopping_list_event.dart';
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';
import 'package:flutter_top_receit/presentation/services/notification_service.dart';
import 'package:flutter_top_receit/presentation/widgets/appbar.dart';
import 'package:flutter_top_receit/presentation/widgets/drawer.dart';
import 'package:flutter_top_receit/presentation/widgets/filter_modal.dart';
import 'package:flutter_top_receit/presentation/widgets/my_recipes/recipe_list.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_event.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? currentBackground;
  bool isFilterApplied = false;
  bool _isMenuOpen = false;
  int _selectedIndex = 0;

  final List<String> _routes = [
    '/home',
    '/allRecipes',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    GoRouter.of(context).go(_routes[index]);
  }

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    _testFollowBloc();
    NotificationService().getToken();
    _getUserData();
    _testGetShoppingList();
  }

  void _testGetShoppingList() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');

    if (userId == null) {
      print('❌ No se encontró userId en SharedPreferences');
      return;
    }

    print('\n=== TEST: OBTENER LISTA DE COMPRA ===');
    print('🆔 UserID: $userId');

    // Obtenemos el Bloc directamente del árbol de widgets (asumiendo que está disponible)
    final shoppingBloc = context.read<ShoppingListBloc>();

    // Escuchamos los estados
    shoppingBloc.stream.listen((state) {
      if (state.isLoading) {
        print('🔄 Cargando...');
      } else if (state.errorMessage != null) {
        print('❌ Error: ${state.errorMessage}');
      } else if (state.shoppingList != null) {
        final list = state.shoppingList!;
        print('✅ Lista obtenida correctamente!');
        print('📋 ID: ${list.id}');
        print('🛒 Items (${list.items.length}):');

        list.items.forEach((item) {
          print('   - ${item.ingredientName}: ${item.quantity} ${item.unit} '
              '| Comprado: ${item.isPurchased ? "✓" : "✗"}');
        });
      }
    });

    // Disparamos el evento
    shoppingBloc.add(GetShoppingListEvent(userId: userId));
    print('Evento "GetShoppingListEvent" enviado al Bloc');
  }

  void _testFollowBloc() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');
    print('No encuentro user: $userId');
    if (userId != null) {
      // Solicitar los seguidores
      print("Solicitando seguidores para userId: $userId");
      context.read<FollowBloc>().add(GetFollowersEvent(userId: userId));

      // Solicitar los usuarios seguidos
      print("Solicitando usuarios seguidos para userId: $userId");
      context.read<FollowBloc>().add(GetFollowingEvent(userId: userId));
    } else {
      print("No se encontró un userId en AuthState.");
    }
  }

  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');
    print('User ID: $userId');
    if (userId != null) {
      print('User ID: $userId');
      context.read<AuthBloc>().add(GetUserEvent(id: userId));
      context.read<FavoriteBloc>().add(GetFavoritesEvent(userId: userId));
    } else {
      print("No user ID found in SharedPreferences.");
    }
  }

  Future<void> _loadBackgroundImage() async {
    final prefs = PreferencesService();
    final bgImage = await prefs.getBackgroundImage();
    setState(() {
      currentBackground = bgImage ?? 'assets/bg9.jpeg';
    });
  }

  void _updateBackground(String newBackground) {
    setState(() {
      currentBackground = newBackground;
    });
  }

  // Función para cambiar el idioma
  void _onLanguageChanged(String languageCode) {
    Locale locale = Locale(languageCode);
    context.read<LanguageBloc>().add(ChangeLanguageEvent(locale));
  }

  void showFilterModal(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterModal(
          userId: userId,
          onFilterApplied: () {
            setState(() {
              isFilterApplied = true;
            });
          },
        );
      },
    );
  }

  void resetFilters() async {
    setState(() {
      isFilterApplied = false;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('titleFilter');
    await prefs.remove('filterFavorites');

    final userId = context.read<AuthBloc>().state.user!.id;
    context.read<RecipeBloc>().add(GetRecipesByUserIdEvent(userId: userId));
  }

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarDefault(
        scaffoldKey: scaffoldKey,
        onLanguageChanged: _onLanguageChanged,
        isOnMainScreen: true,
      ),
      endDrawer: DrawerWidget(
        onBackgroundChanged: _updateBackground,
      ),
      extendBodyBehindAppBar: true,
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.user == null) {
            print("No user found in AuthState.");
            return const Center(child: Text("No se encontraron recetas"));
          }
          final userId = state.user!.id;
          return Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(currentBackground ?? 'assets/bg9.jpeg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: RecipeList(userId: state.user!.id),
                ),
              ),
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  heroTag: "btn1",
                  onPressed: _toggleMenu,
                  // ignore: sort_child_properties_last
                  child: Icon(_isMenuOpen ? Icons.close : Icons.add),
                  backgroundColor: Colors.blue,
                ),
              ),
              if (_isMenuOpen)
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: () {
                      showFilterModal(context, userId);
                    },
                    child: const Icon(Icons.filter_list),
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
              if (_isMenuOpen)
                Positioned(
                  bottom: 140,
                  right: 20,
                  child: FloatingActionButton(
                    heroTag: "btn3",
                    onPressed: resetFilters,
                    child: const Icon(Icons.reset_tv_outlined),
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
              if (_isMenuOpen)
                Positioned(
                  bottom: 200,
                  right: 20,
                  child: FloatingActionButton(
                    heroTag: "btn4",
                    onPressed: () {
                      router.go('/createRecipe');
                    },
                    child: const Icon(Icons.add),
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Recetas Públicas',
          ),
        ],
      ),
    );
  }
}
