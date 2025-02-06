import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/config/router/routes.dart';
import 'package:flutter_top_receit/data/models/ingredient_model.dart';
import 'package:flutter_top_receit/data/models/recipe_ingredient_model.dart';
import 'package:flutter_top_receit/data/models/step_model.dart';
import 'package:flutter_top_receit/domain/entities/recipe_ingredient_entity.dart';
import 'package:flutter_top_receit/domain/entities/steps_entity.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_state.dart';
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';
import 'package:flutter_top_receit/presentation/widgets/all_recipes/view%20recipe%20details/recipe_details.dart';
import 'package:flutter_top_receit/presentation/widgets/all_recipes/view%20recipe%20details/recipe_ingredients_details.dart';
import 'package:flutter_top_receit/presentation/widgets/all_recipes/view%20recipe%20details/steps_details.dart';

class ViewRecipeDetailsScreen extends StatefulWidget {
  final int recipeId;

  const ViewRecipeDetailsScreen({super.key, required this.recipeId});

  @override
  State<ViewRecipeDetailsScreen> createState() =>
      _ViewRecipeDetailsScreenState();
}

class _ViewRecipeDetailsScreenState extends State<ViewRecipeDetailsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? currentBackground;
  bool isImageLoaded = false;

  Future<void> _loadBackgroundImage() async {
    final prefs = PreferencesService();
    final bgImage = await prefs.getBackgroundImage();
    setState(() {
      currentBackground = bgImage ?? 'assets/bg9.jpeg';
    });
  }

  List<StepModel> _convertSteps(List<StepEntity> stepsEntity) {
    return stepsEntity
        .map((stepEntity) => StepModel(
              idStep: stepEntity.idStep,
              order: stepEntity.order,
              description: stepEntity.description,
            ))
        .toList();
  }

  List<RecipeIngredientModel> _convertIngredients(
      List<RecipeIngredientEntity> ingredientsEntity) {
    return ingredientsEntity.map((ingredientEntity) {
      return RecipeIngredientModel(
        idRecipeIngredient: ingredientEntity.idRecipeIngredient,
        quantity: ingredientEntity.quantity,
        unit: ingredientEntity.unit,
        ingredient:
            IngredientModel.fromJson(ingredientEntity.ingredient.toJson()),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    context.read<RecipeBloc>().add(GetRecipeByIdEvent(id: widget.recipeId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipeBloc, RecipeState>(
      listener: (context, state) {
        if (state.isLoading) {
        } else if (state.recipe != null) {
          _titleController.text = state.recipe?.title ?? '';
          _descriptionController.text = state.recipe?.description ?? '';
          _imageUrlController.text = state.recipe?.image ?? '';
          setState(() {
            isImageLoaded = true;
          });
        } else if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(currentBackground ?? '.assets/bg9.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RecipeDetailsScreen(
                      titleController: _titleController,
                      descriptionController: _descriptionController,
                      imageUrlController: _imageUrlController,
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<RecipeBloc, RecipeState>(
                      builder: (context, state) {
                        final ingredients = _convertIngredients(
                            state.recipe?.recipeIngredients ?? []);
                        return RecipeIngredientsDetails(
                          ingredients: ingredients,
                          recipeId: widget.recipeId,
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<RecipeBloc, RecipeState>(
                      builder: (context, state) {
                        // Pasos
                        List<StepModel> steps =
                            _convertSteps(state.recipe?.steps ?? []);
                        return RecipeStepsDetails(
                          steps: steps,
                          recipeId: widget.recipeId,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // Botón para volver atrás
                    ElevatedButton.icon(
                      onPressed: () {
                        router.go('/AllRecipes');
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      label: Text('return'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
