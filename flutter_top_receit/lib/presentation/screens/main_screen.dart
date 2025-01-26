import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/config/router/routes.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';
import 'package:flutter_top_receit/presentation/widgets/appbar.dart';
import 'package:flutter_top_receit/presentation/widgets/drawer.dart';
import 'package:flutter_top_receit/presentation/widgets/filter_modal.dart';
import 'package:flutter_top_receit/presentation/widgets/recipe_list.dart';
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

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');
    if (userId != null) {
      context.read<AuthBloc>().add(GetUserEvent(id: userId));
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

  void resetFilters() {
    setState(() {
      isFilterApplied = false;
    });
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
        onLanguageChanged: _onLanguageChanged, // Pasamos la función aquí
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
                  onPressed: _toggleMenu,
                  child: Icon(_isMenuOpen ? Icons.close : Icons.add),
                  backgroundColor: Colors.blue,
                ),
              ),
              if (_isMenuOpen)
                Positioned(
                  bottom: 80,
                  right: 20,
                  child: FloatingActionButton(
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
                    onPressed: () {
                      router.go('/createRecipe');
                    },
                    child: const Icon(Icons.create),
                    backgroundColor: Colors.blueGrey,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
