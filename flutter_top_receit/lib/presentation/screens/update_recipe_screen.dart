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
import 'package:flutter_top_receit/presentation/widgets/update%20fields/recipe_form.dart'; // Importamos el nuevo widget
import 'package:flutter_top_receit/presentation/widgets/update%20fields/recipe_ingredients.dart';
import 'package:flutter_top_receit/presentation/widgets/update%20fields/steps.dart';
import 'package:flutter_top_receit/presentation/widgets/update%20fields/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateRecipeScreen extends StatefulWidget {
  final int recipeId;

  const UpdateRecipeScreen({super.key, required this.recipeId});

  @override
  State<UpdateRecipeScreen> createState() => _UpdateRecipeScreenState();
}

class _UpdateRecipeScreenState extends State<UpdateRecipeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? currentBackground;
  String? userId;

  bool isImageLoaded = false;

  Future<void> _loadBackgroundImage() async {
    final prefs = PreferencesService();
    final bgImage = await prefs.getBackgroundImage();
    setState(() {
      currentBackground = bgImage ?? 'assets/default_background.jpg';
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

  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('id');
    setState(() {
      userId = storedUserId;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    _getUserData();
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
              image: AssetImage(
                  currentBackground ?? 'assets/default_background.jpg'),
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
                    RecipeForm(
                      titleController: _titleController,
                      descriptionController: _descriptionController,
                      imageUrlController: _imageUrlController,
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<RecipeBloc, RecipeState>(
                      builder: (context, state) {
                        final ingredients = _convertIngredients(
                            state.recipe?.recipeIngredients ?? []);
                        return RecipeIngredients(
                          ingredients: ingredients,
                          recipeId: widget.recipeId,
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<RecipeBloc, RecipeState>(
                      builder: (context, state) {
                        List<StepModel> steps =
                            _convertSteps(state.recipe?.steps ?? []);
                        return RecipeSteps(
                          steps: steps,
                          recipeId: widget.recipeId,
                        );
                      },
                    ),
                    const SizedBox(height: 32),

                    // Botones
                    RecipeButtons(
                      onAccept: () {
                        if (_titleController.text.isNotEmpty &&
                            _descriptionController.text.isNotEmpty &&
                            _imageUrlController.text.isNotEmpty &&
                            userId != null) {
                          context.read<RecipeBloc>().add(
                                UpdateRecipeEvent(
                                  title: _titleController.text,
                                  description: _descriptionController.text,
                                  image: _imageUrlController.text,
                                  idRecipe: widget.recipeId,
                                ),
                              );
                          router.go('/home');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Completa todos los campos')),
                          );
                        }
                      },
                      onCancel: () {
                        router.go('/home');
                      },
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
