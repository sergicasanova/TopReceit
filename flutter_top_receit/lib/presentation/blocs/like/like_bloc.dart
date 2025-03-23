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
      emit(LikeState.loading()); // Cambiar estado a loading

      final result = await giveLikeUseCase.call(event.userId, event.recipeId);
      result.fold(
        (failure) => emit(LikeState.failure("Fallo al dar like a la receta")),
        (_) {
          emit(LikeState.success());
          emit(LikeState.likeUpdated());

          // Verificar el filtro activo y lanzar el evento correcto
          if (recipeBloc.state.followingRecipes != null) {
            recipeBloc.add(GetPublicRecipesByFollowingEvent(
              userId: event.userId,
            ));
          } else {
            recipeBloc.add(GetPublicRecipesEvent());
          }
        },
      );
    });

    on<RemoveLikeEvent>((event, emit) async {
      emit(LikeState.loading()); // Cambiar estado a loading

      final result = await removeLikeUseCase.call(event.userId, event.recipeId);
      result.fold(
        (failure) =>
            emit(LikeState.failure("Fallo al quitar like de la receta")),
        (_) {
          emit(LikeState.success());
          emit(LikeState.likeUpdated());

          // Verificar el filtro activo y lanzar el evento correcto
          if (recipeBloc.state.followingRecipes != null) {
            recipeBloc.add(GetPublicRecipesByFollowingEvent(
              userId: event.userId,
            ));
          } else {
            recipeBloc.add(GetPublicRecipesEvent());
          }
        },
      );
    });

    on<GetLikesEvent>((event, emit) async {
      emit(LikeState.loading()); // Cambiar estado a loading

      final result = await getLikesByRecipeIdUseCase.call(event.recipeId);
      result.fold(
        (failure) =>
            emit(LikeState.failure("Fallo al obtener los likes de la receta")),
        (likeUserIds) {
          emit(LikeState.loadedLikes(likeUserIds));
        },
      );
    });
  }
}
