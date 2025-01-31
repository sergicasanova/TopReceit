import 'package:flutter_top_receit/data/models/favorites_model.dart';

class FavoriteEntity {
  final int idFavorite;
  final int recipeId;
  final String userId;

  FavoriteEntity({
    required this.idFavorite,
    required this.recipeId,
    required this.userId,
  });

  factory FavoriteEntity.fromModel(FavoriteModel model) {
    return FavoriteEntity(
      idFavorite: model.idFavorite,
      recipeId: model.recipeId,
      userId: model.userId,
    );
  }
}
