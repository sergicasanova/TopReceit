import 'package:equatable/equatable.dart';

abstract class FavoriteEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddFavoriteEvent extends FavoriteEvent {
  final String userId;
  final int recipeId;

  AddFavoriteEvent({required this.userId, required this.recipeId});

  @override
  List<Object?> get props => [userId, recipeId];
}

class RemoveFavoriteEvent extends FavoriteEvent {
  final String userId;
  final int recipeId;

  RemoveFavoriteEvent({required this.userId, required this.recipeId});

  @override
  List<Object?> get props => [userId, recipeId];
}

class GetFavoritesEvent extends FavoriteEvent {
  final String userId;

  GetFavoritesEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
