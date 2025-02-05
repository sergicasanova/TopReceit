class LikeModel {
  final int idLike;
  final int recipeId;
  final String userId;

  LikeModel({
    required this.idLike,
    required this.recipeId,
    required this.userId,
  });

  factory LikeModel.fromJson(Map<String, dynamic> json) {
    return LikeModel(
      idLike: json['id_like'],
      recipeId: json['recipe_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_like': idLike,
      'recipe_id': recipeId,
      'user_id': userId,
    };
  }
}
