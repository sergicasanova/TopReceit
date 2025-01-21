import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/domain/usecases/steps/create_step_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/steps/delete_step_by_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/steps/get_steps_by_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/steps/delete_step_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/steps/update_steps_usecase.dart';
import 'package:flutter_top_receit/presentation/blocs/steps/steps_event.dart';
import 'package:flutter_top_receit/presentation/blocs/steps/steps_state.dart';

class StepBloc extends Bloc<StepEvent, StepState> {
  final CreateStepUseCase createStepUseCase;
  final GetStepsByRecipeUseCase getStepsByRecipeUseCase;
  final UpdateStepUseCase updateStepUseCase;
  final DeleteStepUseCase deleteStepUseCase;
  final DeleteStepByIdUseCase deleteStepByIdUseCase;

  StepBloc(
    this.createStepUseCase,
    this.getStepsByRecipeUseCase,
    this.updateStepUseCase,
    this.deleteStepUseCase,
    this.deleteStepByIdUseCase,
  ) : super(StepState.initial()) {
    on<GetStepsByRecipeEvent>((event, emit) async {
      emit(StepState.loading());
      final result = await getStepsByRecipeUseCase.call(event.recipeId);
      result.fold(
        (failure) => emit(StepState.failure('Error al obtener los pasos')),
        (steps) => emit(StepState.loaded(steps)),
      );
    });

    on<CreateStepEvent>((event, emit) async {
      emit(StepState.loading());
      final result = await createStepUseCase.call(event.step);
      result.fold(
        (failure) => emit(StepState.failure('Error al crear el paso')),
        (step) => emit(StepState.created(step)),
      );
    });

    on<UpdateStepEvent>((event, emit) async {
      emit(StepState.loading());
      final result = await updateStepUseCase.call(
        UpdateStepParams(
          recipeId: event.recipeId,
          stepId: event.stepId,
          step: event.step,
        ),
      );
      result.fold(
        (failure) => emit(StepState.failure('Error al actualizar el paso')),
        (step) => emit(StepState.created(step)),
      );
    });

    on<DeleteStepEvent>((event, emit) async {
      emit(StepState.loading());
      final result = await deleteStepUseCase.call(
        DeleteStepParams(recipeId: event.recipeId, stepId: event.stepId),
      );
      result.fold(
        (failure) => emit(StepState.failure('Error al eliminar el paso')),
        (_) => emit(StepState.deleted()),
      );
    });

    on<DeleteStepByIdEvent>((event, emit) async {
      emit(StepState.loading());
      print('delete step by id');
      final result = await deleteStepByIdUseCase.call(event.stepId);
      result.fold(
        (failure) => emit(StepState.failure('Error al eliminar el paso')),
        (_) => emit(StepState.deleted()),
      );
    });
  }
}
