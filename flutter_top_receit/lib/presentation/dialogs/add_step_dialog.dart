import 'package:flutter/material.dart';
import 'package:flutter_top_receit/data/models/step_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/steps/steps_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/steps/steps_event.dart';
import 'package:flutter/services.dart';

class AddStepDialog extends StatefulWidget {
  final int recipeId;

  const AddStepDialog({super.key, required this.recipeId});

  @override
  _AddStepDialogState createState() => _AddStepDialogState();
}

class _AddStepDialogState extends State<AddStepDialog> {
  final TextEditingController _stepController = TextEditingController();
  final TextEditingController _orderController = TextEditingController();

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
              'Agregar Paso',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _orderController,
              decoration: const InputDecoration(
                labelText: 'Número del paso (orden)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _stepController,
              decoration: const InputDecoration(
                labelText: 'Descripción del paso',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
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
                    if (_stepController.text.isNotEmpty &&
                        _orderController.text.isNotEmpty) {
                      final order = int.tryParse(_orderController.text);
                      if (order != null) {
                        final step = StepModel(
                          idRecipe: widget.recipeId,
                          order: order,
                          description: _stepController.text,
                        );
                        context.read<StepBloc>().add(
                              CreateStepEvent(
                                step: step,
                                recipeId: widget.recipeId,
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
                              content: Text(
                                  'Por favor, ingresa un número válido para el paso')),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Por favor, ingresa la descripción y el número del paso')),
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
