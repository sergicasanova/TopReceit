import 'package:flutter/material.dart';
import 'package:flutter_top_receit/data/models/step_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/steps/steps_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/steps/steps_event.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddStepDialog extends StatefulWidget {
  final int recipeId;
  final int? stepId;
  final StepModel? existingStep;

  const AddStepDialog(
      {super.key, required this.recipeId, this.stepId, this.existingStep});

  @override
  _AddStepDialogState createState() => _AddStepDialogState();
}

class _AddStepDialogState extends State<AddStepDialog> {
  final TextEditingController _stepController = TextEditingController();
  final TextEditingController _orderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.existingStep != null) {
      _stepController.text = widget.existingStep!.description;
      _orderController.text = widget.existingStep!.order.toString();
    }
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
            Text(
              widget.stepId == null
                  ? AppLocalizations.of(context)!.add_step_title
                  : ('Editar Paso ${widget.existingStep!.order}'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _orderController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.step_number_label,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _stepController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.step_description_label,
                border: const OutlineInputBorder(),
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
                  child: Text(AppLocalizations.of(context)!.cancel_button),
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
                        if (widget.stepId == null) {
                          // Creating a new step
                          context.read<StepBloc>().add(
                                CreateStepEvent(
                                  step: step,
                                  recipeId: widget.recipeId,
                                ),
                              );
                        } else {
                          // Updating an existing step
                          context.read<StepBloc>().add(
                                UpdateStepEvent(
                                  step: step,
                                  stepId: widget.stepId!,
                                ),
                              );
                        }
                        await Future.delayed(const Duration(seconds: 1));
                        context.read<RecipeBloc>().add(
                              GetRecipeByIdEvent(id: widget.recipeId),
                            );
                        Navigator.of(context).pop();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .step_number_invalid)),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .step_description_and_number_required)),
                      );
                    }
                  },
                  child: Text(widget.stepId == null
                      ? AppLocalizations.of(context)!.add_button
                      : ('Editar')), // traducir
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
