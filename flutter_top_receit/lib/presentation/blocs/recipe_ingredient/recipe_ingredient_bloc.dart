import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/domain/usecases/recipe_ingredient/create_recipe_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe_ingredient/get_all_ingredients_for_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe_ingredient/get_ingredient_by_id_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe_ingredient/update_recipe_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe_ingredient/delete_recipe_ingredient_usecase.dart';

import 'recipe_ingredient_event.dart';
import 'recipe_ingredient_state.dart';

class RecipeIngredientBloc
    extends Bloc<RecipeIngredientEvent, RecipeIngredientState> {
  final CreateRecipeIngredientUseCase createRecipeIngredientUseCase;
  final GetAllIngredientsForRecipeUseCase getAllIngredientsForRecipeUseCase;
  final GetIngredientByIdUseCase getIngredientByIdUseCase;
  final UpdateRecipeIngredientUseCase updateRecipeIngredientUseCase;
  final DeleteRecipeIngredientUseCase deleteRecipeIngredientUseCase;

  RecipeIngredientBloc(
    this.createRecipeIngredientUseCase,
    this.getAllIngredientsForRecipeUseCase,
    this.getIngredientByIdUseCase,
    this.updateRecipeIngredientUseCase,
    this.deleteRecipeIngredientUseCase,
  ) : super(RecipeIngredientState.initial()) {
    on<GetAllIngredientsForRecipeEvent>((event, emit) async {
      emit(RecipeIngredientState.loading());
      final result =
          await getAllIngredientsForRecipeUseCase.call(event.recipeId);
      result.fold(
        (failure) => emit(RecipeIngredientState.failure(
            failure.message ?? 'Error al obtener los ingredientes')),
        (recipeIngredients) =>
            emit(RecipeIngredientState.loaded(recipeIngredients)),
      );
    });

    on<GetIngredientByIdEvent>((event, emit) async {
      emit(RecipeIngredientState.loading());
      final result =
          await getIngredientByIdUseCase.call(event.idRecipeIngredient);
      result.fold(
        (failure) => emit(
            RecipeIngredientState.failure('Error al obtener el ingrediente')),
        (recipeIngredient) =>
            emit(RecipeIngredientState.loadedById(recipeIngredient)),
      );
    });

    on<CreateRecipeIngredientEvent>((event, emit) async {
      emit(RecipeIngredientState.loading());
      final result =
          await createRecipeIngredientUseCase.call(event.recipeIngredient);

      result.fold(
        (failure) {
          emit(RecipeIngredientState.failure('Error al crear el ingrediente'));
        },
        (createdRecipeIngredient) {
          emit(RecipeIngredientState.created(createdRecipeIngredient));
        },
      );
    });

    on<UpdateRecipeIngredientEvent>((event, emit) async {
      emit(RecipeIngredientState.loading());
      final result = await updateRecipeIngredientUseCase.call(
        event.recipeIngredient,
        event.recipeId,
        event.idRecipeIngredient,
      );
      result.fold(
        (failure) => emit(RecipeIngredientState.failure(
            'Error al actualizar el ingrediente')),
        (updatedRecipeIngredient) =>
            emit(RecipeIngredientState.created(updatedRecipeIngredient)),
      );
    });

    on<DeleteRecipeIngredientEvent>((event, emit) async {
      emit(RecipeIngredientState.loading());
      final result = await deleteRecipeIngredientUseCase.call(
        event.recipeId,
        event.idRecipeIngredient!,
      );
      result.fold(
        (failure) => emit(
            RecipeIngredientState.failure('Error al eliminar el ingrediente')),
        (_) => emit(RecipeIngredientState.deleted()),
      );
    });
  }
}
