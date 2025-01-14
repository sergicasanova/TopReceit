import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/data/models/ingredient_model.dart';

abstract class IngredientEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetAllIngredientsEvent extends IngredientEvent {
  final String? name;

  GetAllIngredientsEvent({this.name});

  @override
  List<Object?> get props => [name];
}

class CreateIngredientEvent extends IngredientEvent {
  final IngredientModel ingredient;

  CreateIngredientEvent({required this.ingredient});

  @override
  List<Object?> get props => [ingredient];
}

class DeleteIngredientEvent extends IngredientEvent {
  final int id;

  DeleteIngredientEvent({required this.id});

  @override
  List<Object?> get props => [id];
}
