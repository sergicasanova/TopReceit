import 'package:flutter/material.dart';
import 'package:flutter_top_receit/domain/entities/recipe_entity.dart';
import 'package:go_router/go_router.dart';

class RecipeCard extends StatelessWidget {
  final RecipeEntity recipe;

  const RecipeCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          print('ID de la receta: ${recipe.idRecipe}');
          print('ID del usuario: ${recipe.user!.id}');
          context.go('/recipeDetails/${recipe.idRecipe}', extra: {
            'comesFromUserDetails': true, // Viene de AllRecipes
            'userId': recipe.user!.id,
          });
        },
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: recipe.image!.isNotEmpty
                ? Image.network(
                    recipe.image!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/icons/recipe.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
          ),
          title: Text(
            recipe.title ?? "Sin título",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            recipe.description ?? "Sin descripción",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
