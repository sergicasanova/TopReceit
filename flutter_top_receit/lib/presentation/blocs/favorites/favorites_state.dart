import 'package:equatable/equatable.dart';

class FavoriteState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<int>? favoriteRecipeIds;

  const FavoriteState({
    this.isLoading = false,
    this.errorMessage,
    this.favoriteRecipeIds,
  });

  @override
  List<Object?> get props =>
      [isLoading, errorMessage ?? '', favoriteRecipeIds ?? []];

  FavoriteState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<int>? favoriteRecipeIds,
  }) {
    return FavoriteState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      favoriteRecipeIds: favoriteRecipeIds ?? this.favoriteRecipeIds,
    );
  }

  factory FavoriteState.initial() => const FavoriteState();

  factory FavoriteState.loading() => const FavoriteState(isLoading: true);

  factory FavoriteState.success() => const FavoriteState();

  factory FavoriteState.failure(String errorMessage) =>
      FavoriteState(errorMessage: errorMessage);

  factory FavoriteState.loadedFavorites(List<int> favoriteRecipeIds) =>
      FavoriteState(favoriteRecipeIds: favoriteRecipeIds);
}
