import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_event.dart';
import 'package:flutter_top_receit/presentation/blocs/like/like_state.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/like/like_bloc.dart'; // Importamos el LikeBloc
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';
import 'package:flutter_top_receit/presentation/widgets/all_recipes/all_recipe_list.dart';
import 'package:flutter_top_receit/presentation/widgets/drawer.dart';
import 'package:flutter_top_receit/presentation/widgets/appbar.dart';
import 'package:flutter_top_receit/presentation/widgets/public_user_recipes/public_filter.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllRecipesScreen extends StatefulWidget {
  const AllRecipesScreen({super.key});

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  String? currentBackground;
  int _selectedIndex = 0;
  bool _filterByFollowing = false;
  String? loggedUserId;
  bool _isLoading = false;

  final List<String> _routes = [
    '/home',
    '/allRecipes',
  ];

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedUserId = prefs.getString('id');
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    GoRouter.of(context).go(_routes[index]);
  }

  void _applyFilter(bool filterByFollowing) {
    setState(() {
      _filterByFollowing = filterByFollowing;
    });
    _getRecipes();
  }

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    setState(() {
      _isLoading = true;
    });

    await _loadUserId();
    await _loadBackgroundImage();
    await _getRecipes();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadBackgroundImage() async {
    final prefs = PreferencesService();
    final bgImage = await prefs.getBackgroundImage();
    setState(() {
      currentBackground = bgImage ?? 'assets/bg9.jpeg';
    });
  }

  Future<void> _getRecipes() async {
    print(
        "Cargando recetas. Filtro por usuarios seguidos: $_filterByFollowing");

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');

    if (_filterByFollowing) {
      if (userId != null) {
        print(
            "Solicitando recetas públicas por usuarios seguidos para userId: $userId");
        context
            .read<RecipeBloc>()
            .add(GetPublicRecipesByFollowingEvent(userId: userId));
      } else {
        print("Error: userId es null");
      }
    } else {
      print("Solicitando todas las recetas públicas");
      context.read<RecipeBloc>().add(GetPublicRecipesEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarDefault(
        scaffoldKey: scaffoldKey,
        onLanguageChanged: (languageCode) {
          Locale locale = Locale(languageCode);
          context.read<LanguageBloc>().add(ChangeLanguageEvent(locale));
        },
        isOnMainScreen: false,
      ),
      endDrawer: DrawerWidget(
        onBackgroundChanged: (newBackground) {
          setState(() {
            currentBackground = newBackground;
          });
        },
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
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
          BlocListener<LikeBloc, LikeState>(
            listener: (context, state) {
              if (state.isUpdated) {
                _getRecipes();
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 100),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AllRecipeList(
                      filterByFollowing: _filterByFollowing,
                      loggedUserId: loggedUserId!,
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return FilterModal(
                onFilterApplied: (bool filterByFollowing) {
                  _applyFilter(filterByFollowing);
                },
              );
            },
          );
        },
        child: const Icon(Icons.filter_list),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Maneja el cambio de pestañas
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
