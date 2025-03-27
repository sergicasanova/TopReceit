// ignore_for_file: use_build_context_synchronously, deprecated_member_use

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
import 'package:flutter_top_receit/presentation/widgets/update%20fields/recipe_form.dart';
import 'package:flutter_top_receit/presentation/widgets/update%20fields/recipe_ingredients.dart';
import 'package:flutter_top_receit/presentation/widgets/update%20fields/steps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool _isPublic = false;
  String? currentBackground;
  String? userId;

  bool isImageLoaded = false;

  final GlobalKey<RecipeFormState> _recipeFormKey = GlobalKey();

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

  void _showDeleteConfirmationDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context)!.delete_recipe_confirmation_title),
          content: Text(
              AppLocalizations.of(context)!.delete_recipe_confirmation_content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel_button),
            ),
            TextButton(
              onPressed: () async {
                final imageUrl = _imageUrlController.text;
                context
                    .read<RecipeBloc>()
                    .add(DeleteImageEvent(imageUrl: imageUrl));
                Navigator.of(context).pop();
                context.read<RecipeBloc>().add(
                    DeleteRecipeEvent(id: widget.recipeId, userId: userId!));
                await Future.delayed(const Duration(milliseconds: 300));
                router.go('/home');
              },
              child: Text(AppLocalizations.of(context)!.delete_button),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
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
          _isPublic = state.recipe?.isPublic ?? false;
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
                    _buildCardContainer(
                      child: RecipeForm(
                        key: _recipeFormKey,
                        titleController: _titleController,
                        descriptionController: _descriptionController,
                        imageUrlController: _imageUrlController,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCardContainer(
                      child: SwitchListTile(
                        title: Text(
                          AppLocalizations.of(context)!.publish_label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 2,
                                color: Colors.black,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                        value: _isPublic,
                        onChanged: (bool value) {
                          setState(() {
                            _isPublic = value;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                        inactiveThumbColor: Colors.grey[400],
                        inactiveTrackColor: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCardContainer(
                      child: BlocBuilder<RecipeBloc, RecipeState>(
                        builder: (context, state) {
                          final ingredients = _convertIngredients(
                              state.recipe?.recipeIngredients ?? []);
                          return RecipeIngredients(
                            ingredients: ingredients,
                            recipeId: widget.recipeId,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCardContainer(
                      child: BlocBuilder<RecipeBloc, RecipeState>(
                        builder: (context, state) {
                          List<StepModel> steps =
                              _convertSteps(state.recipe?.steps ?? []);
                          return RecipeSteps(
                            steps: steps,
                            recipeId: widget.recipeId,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Botones principales
                    _buildCardContainer(
                      child: Column(
                        children: [
                          // Botón Aceptar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_recipeFormKey.currentState!.imageFile !=
                                    null) {
                                  if (_imageUrlController.text.isNotEmpty) {
                                    await _recipeFormKey.currentState!
                                        .deleteImage(_imageUrlController.text);
                                  }

                                  final uploadedUrl = await _recipeFormKey
                                      .currentState!
                                      .uploadImage();
                                  if (uploadedUrl != null) {
                                    _imageUrlController.text = uploadedUrl;
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              AppLocalizations.of(context)!
                                                  .image_upload_error)),
                                    );
                                    return;
                                  }
                                }

                                if (_titleController.text.isNotEmpty &&
                                    _descriptionController.text.isNotEmpty &&
                                    _imageUrlController.text.isNotEmpty &&
                                    userId != null) {
                                  context.read<RecipeBloc>().add(
                                        UpdateRecipeEvent(
                                          title: _titleController.text,
                                          description:
                                              _descriptionController.text,
                                          image: _imageUrlController.text,
                                          idRecipe: widget.recipeId,
                                          isPublic: _isPublic,
                                        ),
                                      );
                                  router.go('/home');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .recipe_fields_required)),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.green[700],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                              ),
                              child: Text(
                                  AppLocalizations.of(context)!.accept_button,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Botón Eliminar
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _showDeleteConfirmationDialog,
                              icon: const Icon(Icons.delete, size: 20),
                              label: Text(
                                  AppLocalizations.of(context)!.delete_button,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  )),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red[700],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Botones inferiores
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Botón Cancelar
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              router.go('/home');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.grey[800],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                                AppLocalizations.of(context)!.cancel_button,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Botón Volver
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              router.go('/home');
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue[700],
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 4,
                            ),
                            child:
                                Text(AppLocalizations.of(context)!.back_button,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                          ),
                        ),
                      ],
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
