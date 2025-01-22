import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/data/models/ingredient_model.dart';
import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';
import 'package:flutter_top_receit/domain/entities/ingredient_entity.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe_ingredient/recipe_ingredient_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe_ingredient/recipe_ingredient_event.dart';

class AddIngredientDialog extends StatefulWidget {
  final List<IngredientEntity> ingredients;
  final int recipeId;

  const AddIngredientDialog(
      {super.key, required this.recipeId, required this.ingredients});

  @override
  _AddIngredientDialogState createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<AddIngredientDialog> {
  IngredientEntity? selectedIngredient;
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController unitController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  late List<IngredientEntity> filteredIngredients;

  @override
  void initState() {
    super.initState();
    filteredIngredients = widget.ingredients;
    searchController.addListener(() {
      setState(() {
        filteredIngredients = widget.ingredients
            .where((ingredient) => ingredient.name
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Agregar Ingrediente',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Buscar ingrediente',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<IngredientEntity>(
              value: selectedIngredient,
              hint: const Text('Seleccione un ingrediente'),
              onChanged: (value) {
                setState(() {
                  selectedIngredient = value;
                });
              },
              items: filteredIngredients.map((ingredient) {
                return DropdownMenuItem<IngredientEntity>(
                  value: ingredient,
                  child: Text(ingredient.name),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Ingrediente',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: 'Unidades',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedIngredient != null &&
                        quantityController.text.isNotEmpty &&
                        unitController.text.isNotEmpty) {
                      IngredientModel ingredientModel =
                          IngredientModel.fromEntity(selectedIngredient!);
                      final recipeIngredient = RecipeIngredientModel(
                        idRecipe: widget.recipeId,
                        quantity: int.parse(quantityController.text),
                        unit: unitController.text,
                        ingredient: ingredientModel,
                      );
                      context.read<RecipeIngredientBloc>().add(
                            CreateRecipeIngredientEvent(
                              recipeIngredient: recipeIngredient,
                            ),
                          );
                      await Future.delayed(const Duration(seconds: 1));
                      context.read<RecipeBloc>().add(
                            GetRecipeByIdEvent(id: widget.recipeId),
                          );

                      Navigator.of(context).pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, complete todos los campos'),
                        ),
                      );
                    }
                  },
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
