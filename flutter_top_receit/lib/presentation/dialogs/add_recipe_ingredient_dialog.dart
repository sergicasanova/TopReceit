import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/data/models/ingredient_model.dart';
import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';
import 'package:flutter_top_receit/domain/entities/ingredient_entity.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe_ingredient/recipe_ingredient_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dropdown_search/dropdown_search.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Transparente para mantener el fondo
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.add_ingredient_title),
        backgroundColor:
            Colors.transparent, // Transparent to match dialog style
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Redondeamos los bordes
          ),
          child: Padding(
            // Aquí agregamos padding dentro del contenido del diálogo
            padding: const EdgeInsets.all(
                20.0), // Espaciado alrededor de todo el contenido
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filtro de búsqueda - TextField
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.search_ingredient_label,
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 15), // Espaciado dentro del campo
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 16),

                // DropdownSearch para seleccionar ingrediente
                DropdownSearch<IngredientEntity>(
                  popupProps: PopupProps.bottomSheet(
                    showSearchBox: true,
                    itemBuilder: (context, item, isSelected) {
                      return ListTile(
                        title: Text(item.name),
                      );
                    },
                    searchFieldProps: TextFieldProps(
                      decoration: InputDecoration(
                        labelText:
                            AppLocalizations.of(context)!.ingredient_label,
                        hintText: AppLocalizations.of(context)!
                            .select_ingredient_label,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 15), // Espaciado dentro del campo
                      ),
                    ),
                  ),
                  items: widget.ingredients
                      .where((ingredient) => ingredient.name
                          .toLowerCase()
                          .contains(searchController.text
                              .toLowerCase())) // Filtrado en tiempo real
                      .toList(),
                  itemAsString: (IngredientEntity ingredient) =>
                      ingredient.name,
                  onChanged: (IngredientEntity? ingredient) {
                    setState(() {
                      selectedIngredient = ingredient;
                    });
                  },
                  selectedItem: selectedIngredient,
                ),
                const SizedBox(height: 16),

                // Campo de cantidad
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.quantity_label,
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 15), // Espaciado dentro del campo
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),

                // Campo de tipo de unidades
                TextFormField(
                  controller: unitController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.unit_type_label,
                    border: const OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 15), // Espaciado dentro del campo
                  ),
                ),
                const SizedBox(height: 16),

                // Botones de cancelar y agregar
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(AppLocalizations.of(context)!.cancel_button),
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
                            SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .step_description_and_number_required),
                            ),
                          );
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.add_button),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
