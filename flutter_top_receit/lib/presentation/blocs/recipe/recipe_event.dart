import 'package:equatable/equatable.dart';

abstract class RecipeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllRecipesEvent extends RecipeEvent {}

class GetPublicRecipesEvent extends RecipeEvent {}

class GetRecipeByIdEvent extends RecipeEvent {
  final int id;

  GetRecipeByIdEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetRecipesByUserIdEvent extends RecipeEvent {
  final String userId;

  GetRecipesByUserIdEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CreateRecipeEvent extends RecipeEvent {
  final String title;
  final String description;
  final String image;
  final String userId;

  CreateRecipeEvent({
    required this.title,
    required this.description,
    required this.image,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, description, image, userId];
}

class UpdateRecipeEvent extends RecipeEvent {
  final String title;
  final String description;
  final String image;
  final int idRecipe;
  final bool isPublic;

  UpdateRecipeEvent({
    required this.title,
    required this.description,
    required this.image,
    required this.idRecipe,
    required this.isPublic,
  });

  @override
  List<Object?> get props => [title, description, image, idRecipe, isPublic];
}

class DeleteImageEvent extends RecipeEvent {
  final String imageUrl;

  DeleteImageEvent({required this.imageUrl});

  @override
  List<Object> get props => [imageUrl];
}

class DeleteRecipeEvent extends RecipeEvent {
  final int id;
  final String userId;

  DeleteRecipeEvent({required this.id, required this.userId});

  @override
  List<Object?> get props => [id, userId];
}

class ApplyFilterEvent extends RecipeEvent {
  final String? title;
  final int? steps;
  final int? ingredients;
  final String userId;
  final List<int> favoriteRecipeIds;

  ApplyFilterEvent({
    this.title,
    this.steps,
    this.ingredients,
    required this.userId,
    this.favoriteRecipeIds = const [],
  });

  @override
  List<Object?> get props =>
      [title, steps, ingredients, userId, favoriteRecipeIds];
}

class OrderRecipesEvent extends RecipeEvent {
  final String orderBy;
  final bool ascending;
  final String userId;

  OrderRecipesEvent({
    required this.orderBy,
    required this.ascending,
    required this.userId,
  });

  @override
  List<Object?> get props => [orderBy, ascending, userId];
}
