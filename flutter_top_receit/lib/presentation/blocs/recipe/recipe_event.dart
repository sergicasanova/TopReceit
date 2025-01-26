import 'package:equatable/equatable.dart';

abstract class RecipeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllRecipesEvent extends RecipeEvent {}

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

  UpdateRecipeEvent({
    required this.title,
    required this.description,
    required this.image,
    required this.idRecipe,
  });

  @override
  List<Object?> get props => [title, description, image, idRecipe];
}

class DeleteRecipeEvent extends RecipeEvent {
  final int id;

  DeleteRecipeEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ApplyFilterEvent extends RecipeEvent {
  final String? title;
  final int? steps;
  final int? ingredients;
  final String userId;

  ApplyFilterEvent({
    this.title,
    this.steps,
    this.ingredients,
    required this.userId,
  });

  @override
  List<Object?> get props => [title, steps, ingredients, userId];
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
