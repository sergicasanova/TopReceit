import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/domain/entities/steps_entity.dart';

class StepState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<StepEntity>? steps;
  final StepEntity? step;

  const StepState({
    this.isLoading = false,
    this.errorMessage,
    this.steps,
    this.step,
  });

  @override
  List<Object?> get props => [isLoading, errorMessage, steps, step];

  StepState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<StepEntity>? steps,
    StepEntity? step,
  }) {
    return StepState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      steps: steps ?? this.steps,
      step: step ?? this.step,
    );
  }

  factory StepState.initial() => const StepState();

  factory StepState.loading() => const StepState(isLoading: true);

  factory StepState.loaded(List<StepEntity> steps) => StepState(steps: steps);

  factory StepState.loadedById(StepEntity step) => StepState(step: step);

  factory StepState.created(StepEntity step) => StepState(step: step);

  factory StepState.failure(String errorMessage) =>
      StepState(errorMessage: errorMessage);

  factory StepState.deleted() => const StepState();
}
