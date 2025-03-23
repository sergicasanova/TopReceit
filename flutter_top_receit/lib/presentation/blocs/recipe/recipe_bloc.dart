import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/data/models/recipe_model.dart';
import 'package:flutter_top_receit/domain/repositories/image_repository.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/create_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/get_all_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/get_public_recipes_by_following_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/get_public_recipes_by_id_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/get_public_recipes_usecase.dart';
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
  final GetPublicRecipesUseCase getPublicRecipesUseCase;
  final GetPublicRecipesByUserIdUseCase getPublicRecipesByUserIdUseCase;
  final UpdateRecipeUseCase updateRecipeUseCase;
  final DeleteRecipeUseCase deleteRecipeUseCase;
  final ImageRepository imageRepository;
  final GetPublicRecipesByFollowingUseCase getPublicRecipesByFollowingUseCase;

  RecipeBloc(
    this.createRecipeUseCase,
    this.getAllRecipesUseCase,
    this.getRecipeByIdUseCase,
    this.getRecipesByUserIdUseCase,
    this.getPublicRecipesByUserIdUseCase,
    this.getPublicRecipesUseCase,
    this.updateRecipeUseCase,
    this.deleteRecipeUseCase,
    this.imageRepository,
    this.getPublicRecipesByFollowingUseCase,
  ) : super(RecipeState.initial()) {
    on<GetAllRecipesEvent>((event, emit) async {
      emit(RecipeState.loading());
      final result = await getAllRecipesUseCase.call(NoParams());
      result.fold(
        (failure) => emit(RecipeState.failure("Fallo al obtener las recetas")),
        (recipes) => emit(RecipeState.loaded(recipes)),
      );
    });

    on<GetPublicRecipesByUserIdEvent>((event, emit) async {
      emit(RecipeState.loading());
      final result = await getPublicRecipesByUserIdUseCase.call(event.userId);
      result.fold(
        (failure) => emit(RecipeState.failure(
            "Fallo al obtener las recetas públicas del usuario")),
        (recipes) => emit(RecipeState.publicRecipesByUserLoaded(recipes)),
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
        isPublic: event.isPublic,
      ));
      print("Update recipe result: $result");

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

          // NUEVO: Filtrar recetas según los usuarios seguidos
          if (event.followedUserIds != null &&
              event.followedUserIds!.isNotEmpty) {
            filteredRecipes = filteredRecipes
                .where((recipe) =>
                    event.followedUserIds!.contains(recipe.user!.id))
                .toList();
          }

          emit(RecipeState.loadedRecipes(filteredRecipes));
        },
      );
    });

    on<GetPublicRecipesEvent>((event, emit) async {
      emit(RecipeState.loading());

      final result = await getPublicRecipesUseCase.call(NoParams());

      result.fold(
        (failure) {
          emit(RecipeState.failure("Fallo al obtener las recetas públicas"));
        },
        (recipes) {
          emit(RecipeState.publicRecipesLoaded(recipes));
        },
      );
    });

    on<GetPublicRecipesByFollowingEvent>((event, emit) async {
      emit(RecipeState.loading());

      final result = await getPublicRecipesByFollowingUseCase(event.userId);

      result.fold(
        (failure) {
          emit(RecipeState.failure(
              "Error al obtener las recetas públicas de usuarios seguidos"));
        },
        (recipes) {
          emit(RecipeState.followingRecipesLoaded(recipes));
        },
      );
    });

    on<ApplyPublicFilterEvent>((event, emit) async {
      emit(RecipeState.loading());
      print("Evento ApplyPublicFilterEvent recibido");
      print("Título filtro: ${event.title}");
      print("Pasos filtro: ${event.steps}");
      print("Ingredientes filtro: ${event.ingredients}");
      print("IDs de usuarios seguidos: ${event.followedUserIds}");

      final result = await getPublicRecipesUseCase.call(NoParams());
      result.fold(
        (failure) {
          print("Error al obtener recetas públicas: ${failure.toString()}");
          emit(RecipeState.failure("Fallo al obtener las recetas públicas"));
        },
        (recipes) {
          print("Recetas públicas obtenidas: ${recipes.length}");
          var filteredRecipes = recipes;

          // Filtrar por título
          if (event.title != null && event.title!.isNotEmpty) {
            filteredRecipes = filteredRecipes
                .where((recipe) => recipe.title!
                    .toLowerCase()
                    .contains(event.title!.toLowerCase()))
                .toList();
            print("Recetas filtradas por título: ${filteredRecipes.length}");
          }

          // Filtrar por número de pasos
          if (event.steps != null) {
            filteredRecipes = filteredRecipes
                .where((recipe) => recipe.steps.length <= event.steps!)
                .toList();
            print("Recetas filtradas por pasos: ${filteredRecipes.length}");
          }

          // Filtrar por número de ingredientes
          if (event.ingredients != null) {
            filteredRecipes = filteredRecipes
                .where((recipe) =>
                    recipe.recipeIngredients.length <= event.ingredients!)
                .toList();
            print(
                "Recetas filtradas por ingredientes: ${filteredRecipes.length}");
          }

          // Filtrar según los usuarios seguidos
          if (event.followedUserIds != null &&
              event.followedUserIds!.isNotEmpty) {
            filteredRecipes = filteredRecipes
                .where((recipe) =>
                    event.followedUserIds!.contains(recipe.user!.id))
                .toList();
            print(
                "Recetas filtradas por usuarios seguidos: ${filteredRecipes.length}");
          }

          emit(RecipeState.publicRecipesLoaded(filteredRecipes));
          print(
              "Estado emitido con recetas filtradas: ${filteredRecipes.length}");
        },
      );
    });
  }
}
