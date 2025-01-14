class RecipeModel {
  final String idRecipe;
  final String idUser;
  final String title;
  final String description;
  final List<String> recipeIngredients;
  final List<String> steps;
  final String image;

  RecipeModel({
    required this.idRecipe,
    required this.idUser,
    required this.title,
    required this.description,
    required this.recipeIngredients,
    required this.steps,
    required this.image,
  });
}
