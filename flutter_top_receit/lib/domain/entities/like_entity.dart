import 'package:flutter_top_receit/data/models/like_model.dart';

class LikeEntity {
  final int idLike;
  final int recipeId;
  final String userId;

  LikeEntity({
    required this.idLike,
    required this.recipeId,
    required this.userId,
  });

  factory LikeEntity.fromModel(LikeModel model) {
    return LikeEntity(
      idLike: model.idLike,
      recipeId: model.recipeId,
      userId: model.userId,
    );
  }
}
