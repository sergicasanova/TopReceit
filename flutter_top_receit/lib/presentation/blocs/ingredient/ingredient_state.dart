import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/data/models/ingredient_model.dart';
import 'package:flutter_top_receit/domain/entities/ingredient_entity.dart';

class IngredientState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<IngredientEntity>? ingredients;
  final IngredientModel? ingredient;

  const IngredientState({
    this.isLoading = false,
    this.errorMessage,
    this.ingredients,
    this.ingredient,
  });

  @override
  List<Object?> get props => [isLoading, errorMessage, ingredients, ingredient];

  IngredientState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<IngredientEntity>? ingredients,
    IngredientModel? ingredient,
  }) {
    return IngredientState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      ingredients: ingredients ?? this.ingredients,
      ingredient: ingredient ?? this.ingredient,
    );
  }

  factory IngredientState.initial() => const IngredientState();

  factory IngredientState.loading() => const IngredientState(isLoading: true);

  factory IngredientState.success() => const IngredientState();

  factory IngredientState.loaded(List<IngredientEntity> ingredients) =>
      IngredientState(ingredients: ingredients);

  factory IngredientState.created(IngredientModel ingredient) =>
      IngredientState(ingredient: ingredient);

  factory IngredientState.failure(String errorMessage) =>
      IngredientState(errorMessage: errorMessage);

  factory IngredientState.deleted() => const IngredientState();
}
