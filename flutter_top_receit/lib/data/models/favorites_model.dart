class FavoriteModel {
  final int idFavorite;
  final int recipeId;
  final String userId;

  FavoriteModel(
      {required this.idFavorite, required this.recipeId, required this.userId});

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      idFavorite: json['id_favorite'],
      recipeId: json['recipe_id'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_favorite': idFavorite,
      'recipe_id': recipeId,
      'user_id': userId,
    };
  }
}
