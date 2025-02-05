import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/domain/usecases/like/get_likes_by_recipe_id_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/like/give_like_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/like/remove_like_usecase.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'like_event.dart';
import 'like_state.dart';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final GiveLikeUseCase giveLikeUseCase;
  final RemoveLikeUseCase removeLikeUseCase;
  final GetLikesByRecipeIdUseCase getLikesByRecipeIdUseCase;
  final RecipeBloc recipeBloc;

  LikeBloc(
    this.giveLikeUseCase,
    this.removeLikeUseCase,
    this.getLikesByRecipeIdUseCase,
    this.recipeBloc,
  ) : super(LikeState.initial()) {
    on<GiveLikeEvent>((event, emit) async {
      emit(LikeState.loading());
      final result = await giveLikeUseCase.call(event.userId, event.recipeId);
      result.fold(
        (failure) => emit(LikeState.failure("Fallo al dar like a la receta")),
        (_) {
          emit(LikeState.success());
          print("Disparando GetAllRecipesEvent desde LikeBloc");
          recipeBloc.add(GetAllRecipesEvent());
        },
      );
    });

    on<RemoveLikeEvent>((event, emit) async {
      emit(LikeState.loading());
      final result = await removeLikeUseCase.call(event.userId, event.recipeId);
      result.fold(
        (failure) =>
            emit(LikeState.failure("Fallo al quitar like de la receta")),
        (_) {
          emit(LikeState.success());
          print("Disparando GetAllRecipesEvent desde LikeBloc");
          recipeBloc.add(GetAllRecipesEvent());
        },
      );
    });

    on<GetLikesEvent>((event, emit) async {
      emit(LikeState.loading());
      final result = await getLikesByRecipeIdUseCase.call(event.recipeId);
      print("Getting likes by recipe id: ${event.recipeId}");
      result.fold(
        (failure) =>
            emit(LikeState.failure("Fallo al obtener los likes de la receta")),
        (likeUserIds) {
          print(likeUserIds);
          emit(LikeState.loadedLikes(likeUserIds));
        },
      );
    });
  }
}
