import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterModal extends StatefulWidget {
  final String userId;
  final Function onFilterApplied;

  const FilterModal(
      {super.key, required this.userId, required this.onFilterApplied});

  @override
  _FilterModalState createState() => _FilterModalState();
}

class _FilterModalState extends State<FilterModal> {
  final TextEditingController _titleController = TextEditingController();
  String? _selectedStepsFilter;
  String? _selectedIngredientsFilter;
  bool _filterByFavorites = false;

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  void _loadFilters() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _titleController.text = prefs.getString('titleFilter') ?? '';
      _filterByFavorites = prefs.getBool('filterFavorites') ?? false;
    });
  }

  void _saveFilters(String title, String? stepsFilter,
      String? ingredientsFilter, bool filterFavorites) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('titleFilter', title);
    prefs.setBool('filterFavorites', filterFavorites);
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.title_label,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedStepsFilter,
                hint: Text(AppLocalizations.of(context)!.filter_steps_hint),
                onChanged: (value) {
                  setState(() {
                    _selectedStepsFilter = value;
                  });
                },
                items: [
                  AppLocalizations.of(context)!.less_than_5_steps,
                  AppLocalizations.of(context)!.less_than_10_steps,
                  AppLocalizations.of(context)!.less_than_15_steps,
                  AppLocalizations.of(context)!.more_than_15_steps,
                ].map((label) {
                  return DropdownMenuItem<String>(
                    value: label,
                    child: Text(label),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.filter_steps_label,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedIngredientsFilter,
                hint:
                    Text(AppLocalizations.of(context)!.filter_ingredients_hint),
                onChanged: (value) {
                  setState(() {
                    _selectedIngredientsFilter = value;
                  });
                },
                items: [
                  AppLocalizations.of(context)!.less_than_5_ingredients,
                  AppLocalizations.of(context)!.less_than_10_ingredients,
                  AppLocalizations.of(context)!.less_than_15_ingredients,
                  AppLocalizations.of(context)!.more_than_15_ingredients,
                ].map((label) {
                  return DropdownMenuItem<String>(
                    value: label,
                    child: Text(label),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.filter_ingredients_label,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(AppLocalizations.of(context)!.filter_favorites_label),
                  Switch(
                    value: _filterByFavorites,
                    onChanged: (value) {
                      setState(() {
                        _filterByFavorites = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  final titleFilter = _titleController.text;
                  final stepsFilter = _selectedStepsFilter;
                  final ingredientsFilter = _selectedIngredientsFilter;

                  final favoriteState = context.read<FavoriteBloc>().state;
                  final favoriteRecipeIds =
                      favoriteState.favoriteRecipeIds ?? [];

                  context.read<RecipeBloc>().add(ApplyFilterEvent(
                        title: titleFilter,
                        steps: _mapStepFilterToInt(stepsFilter),
                        ingredients:
                            _mapIngredientFilterToInt(ingredientsFilter),
                        userId: widget.userId,
                        favoriteRecipeIds:
                            _filterByFavorites ? favoriteRecipeIds : [],
                      ));

                  _saveFilters(titleFilter, stepsFilter, ingredientsFilter,
                      _filterByFavorites);

                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)!.filter_button),
              ),
            ],
          ),
        );
      },
    );
  }

  int? _mapStepFilterToInt(String? stepFilter) {
    switch (stepFilter) {
      case 'Menos de 5 pasos':
        return 5;
      case 'Menos de 10 pasos':
        return 10;
      case 'Menos de 15 pasos':
        return 15;
      case 'Más de 15 pasos':
        return 16;
      default:
        return null;
    }
  }

  int? _mapIngredientFilterToInt(String? ingredientFilter) {
    switch (ingredientFilter) {
      case 'Menos de 5 ingredientes':
        return 5;
      case 'Menos de 10 ingredientes':
        return 10;
      case 'Menos de 15 ingredientes':
        return 15;
      case 'Más de 15 ingredientes':
        return 16;
      default:
        return null;
    }
  }
}
