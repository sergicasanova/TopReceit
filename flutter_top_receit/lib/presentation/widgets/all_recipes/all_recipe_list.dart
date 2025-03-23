import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/config/router/routes.dart';
import 'package:flutter_top_receit/presentation/blocs/like/like_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/like/like_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_state.dart';
import 'package:flutter_top_receit/presentation/widgets/all_recipes/all_recipe_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllRecipeList extends StatelessWidget {
  final bool filterByFollowing;
  final String? loggedUserId;

  const AllRecipeList(
      {super.key, required this.filterByFollowing, this.loggedUserId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!));
        }

        final recipesToDisplay = filterByFollowing
            ? state.followingRecipes ?? []
            : state.publicRecipes ?? [];

        print("Recetas preparadas para mostrar en ListView:");
        for (var recipe in recipesToDisplay) {
          print("- ID: ${recipe.idRecipe}, Título: ${recipe.title}");
        }
        print("Total de recetas a mostrar: ${recipesToDisplay.length}");

        if (recipesToDisplay.isEmpty) {
          return const Center(child: Text('No hay recetas disponibles'));
        }

        return FutureBuilder<String?>(
          future: SharedPreferences.getInstance()
              .then((prefs) => prefs.getString('id')),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData) {
              return const Center(
                  child: Text("No se encontró el ID de usuario."));
            }

            final loggedUserId = snapshot.data;

            return ListView.builder(
              itemCount: recipesToDisplay.length,
              itemBuilder: (context, index) {
                final recipe = recipesToDisplay[index];
                return AllRecipeCard(
                  title: recipe.title ?? 'Título no disponible',
                  description:
                      recipe.description ?? 'Descripción no disponible',
                  image: recipe.image ?? 'assets/default_image.png',
                  userAvatar: recipe.user?.avatar ?? '',
                  userName: recipe.user?.username ?? 'Usuario desconocido',
                  ingredientsCount: recipe.recipeIngredients.length,
                  stepsCount: recipe.steps.length,
                  recipeId: recipe.idRecipe!,
                  userId: recipe.user?.id ?? 'ID desconocido',
                  likeUserIds: recipe.likeUserIds ?? [],
                  loggedUserId: loggedUserId,
                  onTap: () {
                    context.read<LikeBloc>().add(GiveLikeEvent(
                          userId: loggedUserId!,
                          recipeId: recipe.idRecipe!,
                        ));
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
