import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/config/router/routes.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_state.dart';
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';
import 'package:flutter_top_receit/presentation/widgets/all%20recipes/all_recipe_card.dart';
import 'package:flutter_top_receit/presentation/widgets/drawer.dart';
import 'package:flutter_top_receit/presentation/widgets/appbar.dart';

class AllRecipesScreen extends StatefulWidget {
  const AllRecipesScreen({super.key});

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  String? currentBackground;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    _getRecipes();
  }

  Future<void> _loadBackgroundImage() async {
    final prefs = PreferencesService();
    final bgImage = await prefs.getBackgroundImage();
    setState(() {
      currentBackground = bgImage ?? 'assets/bg9.jpeg';
    });
  }

  void _getRecipes() {
    context.read<RecipeBloc>().add(GetAllRecipesEvent());
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
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: SingleChildScrollView(
              child: BlocBuilder<RecipeBloc, RecipeState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.errorMessage != null) {
                    return Center(child: Text(state.errorMessage!));
                  }

                  if (state.recipes == null || state.recipes!.isEmpty) {
                    return const Center(
                        child: Text("No hay recetas disponibles"));
                  }
                  final recipes = state.recipes!;

                  return Column(
                    children: recipes.map((recipe) {
                      return AllRecipeCard(
                        title: recipe.title ?? 'Titulo no disponible',
                        description:
                            recipe.description ?? 'Descripción no disponible',
                        image: recipe.image ?? 'assets/default_image.png',
                        userAvatar: recipe.user!.avatar,
                        userName: recipe.user!.username,
                        ingredientsCount: recipe.recipeIngredients.length,
                        stepsCount: recipe.steps.length,
                        recipeId: recipe.idRecipe!,
                        userId: recipe.user!.id,
                        likeUserIds: recipe.likeUserIds ?? [],
                        onTap: () {
                          router.go('/recipeDetails/${recipe.idRecipe}');
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
