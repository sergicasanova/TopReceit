import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/config/router/routes.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_state.dart';
import 'package:flutter_top_receit/presentation/widgets/all_recipes/all_recipe_card.dart';

class AllRecipeList extends StatelessWidget {
  const AllRecipeList({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<RecipeBloc>().add(GetPublicRecipesEvent());

    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!));
        }

        if (state.recipes == null || state.recipes!.isEmpty) {
          return const Center(child: Text('No hay recetas disponibles'));
        }

        final recipesToDisplay = state.recipes ?? [];

        return ListView.builder(
          itemCount: recipesToDisplay.length,
          itemBuilder: (context, index) {
            final recipe = recipesToDisplay[index];
            return AllRecipeCard(
              title: recipe.title ?? 'Titulo no disponible',
              description: recipe.description ?? 'Descripción no disponible',
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
          },
        );
      },
    );
  }
}
