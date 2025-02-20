import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe_ingredient/recipe_ingredient_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe_ingredient/recipe_ingredient_event.dart';
import 'package:flutter_top_receit/presentation/blocs/ingredient/ingredient_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/ingredient/ingredient_event.dart';
import 'package:flutter_top_receit/presentation/blocs/ingredient/ingredient_state.dart';
import 'package:flutter_top_receit/presentation/dialogs/add_recipe_ingredient_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        Text(
          AppLocalizations.of(context)!.ingredient_list_title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
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
            children: [
              Column(
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
                                    idRecipeIngredient:
                                        ingredient.idRecipeIngredient,
                                  ),
                                );

                            await Future.delayed(const Duration(seconds: 1));

                            // ignore: use_build_context_synchronously
                            context
                                .read<RecipeBloc>()
                                .add(GetRecipeByIdEvent(id: recipeId));
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.add_circle,
                      color: Colors.green, size: 30),
                  onPressed: () {
                    context
                        .read<IngredientBloc>()
                        .add(GetAllIngredientsEvent());
                    showDialog(
                      context: context,
                      builder: (context) {
                        return BlocBuilder<IngredientBloc, IngredientState>(
                          builder: (context, state) {
                            if (state.isLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (state.errorMessage != null) {
                              return Center(child: Text(state.errorMessage!));
                            }

                            if (state.ingredients != null &&
                                state.ingredients!.isNotEmpty) {
                              return AddIngredientDialog(
                                recipeId: recipeId,
                                ingredients: state.ingredients!,
                              );
                            } else {
                              return const Center(
                                  child:
                                      Text('No hay ingredientes disponibles.'));
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
