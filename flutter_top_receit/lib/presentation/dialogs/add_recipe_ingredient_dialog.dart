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
  // ignore: library_private_types_in_public_api
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
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 15),
                      ),
                    ),
                  ),
                  items: widget.ingredients
                      .where((ingredient) => ingredient.name
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase()))
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
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.quantity_label,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: unitController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.unit_type_label,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
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
                          // ignore: use_build_context_synchronously
                          context.read<RecipeBloc>().add(
                                GetRecipeByIdEvent(id: widget.recipeId),
                              );

                          // ignore: use_build_context_synchronously
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
