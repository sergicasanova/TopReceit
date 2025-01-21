import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/config/router/routes.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_state.dart';
import 'package:flutter_top_receit/presentation/widgets/recipe_card.dart';

class RecipeList extends StatelessWidget {
  final String userId;

  const RecipeList({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    context.read<RecipeBloc>().add(GetRecipesByUserIdEvent(userId: userId));

    return BlocBuilder<RecipeBloc, RecipeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.errorMessage != null) {
          return Center(child: Text(state.errorMessage!));
        }

        if (state.recipes != null && state.recipes!.isEmpty) {
          return const Center(child: Text('No tienes recetas'));
        }

        if (state.recipes != null) {
          return ListView.builder(
            itemCount: state.recipes!.length,
            itemBuilder: (context, index) {
              final recipe = state.recipes![index];
              return RecipeCard(
                title: recipe.title ?? 'Titulo no disponible',
                description: recipe.description ?? 'Descripción no disponible',
                image: recipe.image ?? '../../../assets/bg1.jpeg',
                ingredientsCount: recipe.recipeIngredients.length,
                stepsCount: recipe.steps.length,
                onTap: () {
                  router.go('/updateRecipe/${recipe.idRecipe}');
                },
              );
            },
          );
        }

        return const Center(child: Text('No recetas disponibles.'));
      },
    );
  }
}
