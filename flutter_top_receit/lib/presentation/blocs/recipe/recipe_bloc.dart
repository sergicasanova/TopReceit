import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/data/models/recipe_model.dart';
import 'package:flutter_top_receit/domain/repositories/image_repository.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/create_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/get_all_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/get_recipe_by_id_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/get_recipe_by_user_id_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/update_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/delete_recipe_usecase.dart';

import 'recipe_event.dart';
import 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final CreateRecipeUseCase createRecipeUseCase;
  final GetAllRecipesUseCase getAllRecipesUseCase;
  final GetRecipeByIdUseCase getRecipeByIdUseCase;
  final GetRecipesByUserIdUseCase getRecipesByUserIdUseCase;
  final UpdateRecipeUseCase updateRecipeUseCase;
  final DeleteRecipeUseCase deleteRecipeUseCase;
  final ImageRepository imageRepository;

  RecipeBloc(
    this.createRecipeUseCase,
    this.getAllRecipesUseCase,
    this.getRecipeByIdUseCase,
    this.getRecipesByUserIdUseCase,
    this.updateRecipeUseCase,
    this.deleteRecipeUseCase,
    this.imageRepository,
  ) : super(RecipeState.initial()) {
    on<GetAllRecipesEvent>((event, emit) async {
      emit(RecipeState.loading());
      final result = await getAllRecipesUseCase.call(NoParams());
      result.fold(
        (failure) => emit(RecipeState.failure("Fallo al obtener las recetas")),
        (recipes) => emit(RecipeState.loaded(recipes)),
      );
    });

    on<GetRecipeByIdEvent>((event, emit) async {
      emit(RecipeState.loading());
      try {
        final result = await getRecipeByIdUseCase.call(event.id);
        result.fold(
          (failure) {
            emit(RecipeState.failure("Fallo al obtener la receta"));
          },
          (recipe) {
            emit(RecipeState.loadedRecipe(recipe));
          },
        );
      } catch (e) {
        print("Error al obtener receta: $e");
        emit(RecipeState.failure("Fallo al obtener la receta"));
      }
    });

    on<GetRecipesByUserIdEvent>((event, emit) async {
      emit(RecipeState.loading());
      final result = await getRecipesByUserIdUseCase.call(event.userId);
      result.fold(
        (failure) {
          print("Error al obtener las recetas del usuario: ${failure.message}");
          emit(RecipeState.failure("Fallo al obtener las recetas del usuario"));
        },
        (recipes) {
          emit(RecipeState.loadedRecipes(recipes));
        },
      );
    });

    on<CreateRecipeEvent>((event, emit) async {
      emit(RecipeState.loading());

      final params = CreateRecipeParams(
        title: event.title,
        description: event.description,
        image: event.image,
        userId: event.userId,
      );

      final result = await createRecipeUseCase.call(params);

      result.fold(
        (failure) => emit(RecipeState.failure("Fallo al crear la receta")),
        (recipe) {
          add(GetRecipesByUserIdEvent(userId: event.userId.toString()));
          emit(RecipeState.created(
              event.title, event.description, event.image, event.userId));
        },
      );
    });

    on<UpdateRecipeEvent>((event, emit) async {
      emit(RecipeState.loading());
      final result = await updateRecipeUseCase.call(UpdateRecipeDto(
        idRecipe: event.idRecipe,
        title: event.title,
        description: event.description,
        image: event.image,
      ));

      result.fold(
        (failure) => emit(RecipeState.failure(
            "Fallo al actualizar la receta: ${failure.message}")),
        (success) => success
            ? emit(RecipeState.success())
            : emit(RecipeState.failure("Fallo al actualizar la receta")),
      );
    });

    on<DeleteImageEvent>((event, emit) async {
      emit(RecipeState.loading());
      try {
        // Eliminar la imagen en Firebase Storage
        final deleteImageResult =
            await imageRepository.deleteImage(event.imageUrl);

        deleteImageResult.fold(
          (error) {
            print('Failed to delete image: $error');
            emit(RecipeState.failure("Failed to delete image"));
          },
          (success) {
            print('Image deleted successfully.');
            emit(RecipeState.imageDeleted());
          },
        );
      } catch (e) {
        emit(RecipeState.failure('Failed to delete image'));
      }
    });

    on<DeleteRecipeEvent>((event, emit) async {
      emit(RecipeState.loading());
      final result = await deleteRecipeUseCase.call(event.id);
      result.fold(
        (failure) => emit(RecipeState.failure("Fallo al eliminar la receta")),
        (_) {
          print("Receta eliminada ${event.userId}");
          emit(RecipeState.deleted());
          add(GetRecipesByUserIdEvent(userId: event.userId));
        },
      );
    });

    on<ApplyFilterEvent>((event, emit) async {
      emit(RecipeState.loading());

      final result = await getRecipesByUserIdUseCase.call(event.userId);
      result.fold(
        (failure) {
          emit(RecipeState.failure("Fallo al obtener las recetas del usuario"));
        },
        (recipes) {
          var filteredRecipes = recipes;

          if (event.title != null && event.title!.isNotEmpty) {
            filteredRecipes = filteredRecipes
                .where((recipe) => recipe.title!
                    .toLowerCase()
                    .contains(event.title!.toLowerCase()))
                .toList();
          }

          if (event.steps != null) {
            filteredRecipes = filteredRecipes
                .where((recipe) => recipe.steps.length <= event.steps!)
                .toList();
          }

          if (event.ingredients != null) {
            filteredRecipes = filteredRecipes
                .where((recipe) =>
                    recipe.recipeIngredients.length <= event.ingredients!)
                .toList();
          }

          if (event.favoriteRecipeIds.isNotEmpty) {
            filteredRecipes = filteredRecipes
                .where((recipe) =>
                    event.favoriteRecipeIds.contains(recipe.idRecipe))
                .toList();
          }

          emit(RecipeState.loadedRecipes(filteredRecipes));
        },
      );
    });
  }
}
