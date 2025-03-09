import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/data/models/step_model.dart';

abstract class StepEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetStepsByRecipeEvent extends StepEvent {
  final int recipeId;

  GetStepsByRecipeEvent({required this.recipeId});

  @override
  List<Object?> get props => [recipeId];
}

class GetStepByIdEvent extends StepEvent {
  final int stepId;

  GetStepByIdEvent({required this.stepId});

  @override
  List<Object?> get props => [stepId];
}

class CreateStepEvent extends StepEvent {
  final StepModel step;
  final int recipeId;

  CreateStepEvent({required this.step, required this.recipeId});

  @override
  List<Object?> get props => [step, recipeId];
}

class UpdateStepEvent extends StepEvent {
  final StepModel step;
  final int stepId;

  UpdateStepEvent({
    required this.step,
    required this.stepId,
  });

  @override
  List<Object?> get props => [step, stepId];
}

class DeleteStepEvent extends StepEvent {
  final int recipeId;
  final int stepId;

  DeleteStepEvent({required this.recipeId, required this.stepId});

  @override
  List<Object?> get props => [recipeId, stepId];
}

class DeleteStepByIdEvent extends StepEvent {
  final int stepId;

  DeleteStepByIdEvent({required this.stepId});

  @override
  List<Object?> get props => [stepId];
}
