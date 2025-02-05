import 'package:equatable/equatable.dart';

abstract class LikeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GiveLikeEvent extends LikeEvent {
  final String userId;
  final int recipeId;

  GiveLikeEvent({required this.userId, required this.recipeId});

  @override
  List<Object?> get props => [userId, recipeId];
}

class RemoveLikeEvent extends LikeEvent {
  final String userId;
  final int recipeId;

  RemoveLikeEvent({required this.userId, required this.recipeId});

  @override
  List<Object?> get props => [userId, recipeId];
}

class GetLikesEvent extends LikeEvent {
  final int recipeId;

  GetLikesEvent({required this.recipeId});

  @override
  List<Object?> get props => [recipeId];
}
