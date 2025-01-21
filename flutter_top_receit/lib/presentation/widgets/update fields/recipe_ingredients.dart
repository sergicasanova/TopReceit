import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe_ingredient/recipe_ingredient_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe_ingredient/recipe_ingredient_event.dart';

class RecipeIngredients extends StatelessWidget {
  final List<RecipeIngredientModel> ingredients;
  final int recipeId;

  const RecipeIngredients(
      {super.key, required this.ingredients, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lista de Ingredientes:',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ingredients.map((ingredient) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.fastfood, size: 20),
                        const SizedBox(width: 5),
                        Text(
                          '${ingredient.ingredient.name} - ${ingredient.quantity} ${ingredient.unit}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        context.read<RecipeIngredientBloc>().add(
                              DeleteRecipeIngredientEvent(
                                recipeId: recipeId,
                                idRecipeIngredient:
                                    ingredient.idRecipeIngredient,
                              ),
                            );

                        await Future.delayed(const Duration(seconds: 1));

                        context
                            .read<RecipeBloc>()
                            .add(GetRecipeByIdEvent(id: recipeId));
                      },
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
