import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/data/models/step_model.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/steps/steps_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/steps/steps_event.dart';
import 'package:flutter_top_receit/presentation/dialogs/add_step_dialog.dart';

class RecipeSteps extends StatelessWidget {
  final List<StepModel> steps;
  final int recipeId;

  const RecipeSteps({super.key, required this.steps, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pasos:',
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
            children: [
              // Lista de pasos
              Column(
                children: steps.map((step) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check_circle, size: 20),
                            const SizedBox(width: 5),
                            SizedBox(
                                width: 300,
                                child: Text(
                                  'Paso ${step.order}: ${step.description}',
                                  style: const TextStyle(fontSize: 16),
                                  softWrap: true,
                                )),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            context.read<StepBloc>().add(
                                  DeleteStepByIdEvent(stepId: step.idStep!),
                                );
                            await Future.delayed(const Duration(seconds: 1));
                            context.read<RecipeBloc>().add(
                                  GetRecipeByIdEvent(id: recipeId),
                                );
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddStepDialog(recipeId: recipeId);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
