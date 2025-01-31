import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/domain/usecases/favorites/add_favorite_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/favorites/get_favorites_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/favorites/remove_favorite_usecase.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final AddFavoriteUseCase addFavoriteUseCase;
  final RemoveFavoriteUseCase removeFavoriteUseCase;
  final GetFavoritesUseCase getFavoritesUseCase;

  FavoriteBloc(
    this.addFavoriteUseCase,
    this.removeFavoriteUseCase,
    this.getFavoritesUseCase,
  ) : super(FavoriteState.initial()) {
    on<AddFavoriteEvent>((event, emit) async {
      emit(FavoriteState.loading());
      final result =
          await addFavoriteUseCase.call(event.userId, event.recipeId);
      result.fold(
        (failure) => emit(
            FavoriteState.failure("Fallo al agregar la receta a favoritos")),
        (_) {
          emit(FavoriteState.success());
          add(GetFavoritesEvent(userId: event.userId));
        },
      );
    });

    on<RemoveFavoriteEvent>((event, emit) async {
      emit(FavoriteState.loading());
      final result =
          await removeFavoriteUseCase.call(event.userId, event.recipeId);
      result.fold(
        (failure) => emit(
            FavoriteState.failure("Fallo al eliminar la receta de favoritos")),
        (_) {
          emit(FavoriteState.success());
          add(GetFavoritesEvent(userId: event.userId));
        },
      );
    });

    on<GetFavoritesEvent>((event, emit) async {
      emit(FavoriteState.loading());
      final result = await getFavoritesUseCase.call(event.userId);
      result.fold(
        (failure) =>
            emit(FavoriteState.failure("Fallo al obtener los favoritos")),
        (favoriteRecipeIds) {
          emit(FavoriteState.loadedFavorites(favoriteRecipeIds));
        },
      );
    });
  }
}
