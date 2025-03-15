import 'package:equatable/equatable.dart';

abstract class FollowEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Evento para obtener los seguidores de un usuario
class GetFollowersEvent extends FollowEvent {
  final String userId;

  GetFollowersEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// Evento para obtener la lista de usuarios seguidos por un usuario
class GetFollowingEvent extends FollowEvent {
  final String userId;

  GetFollowingEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// Evento para seguir a un usuario
class FollowUserEvent extends FollowEvent {
  final String followerId;
  final String followedId;

  FollowUserEvent({
    required this.followerId,
    required this.followedId,
  });

  @override
  List<Object?> get props => [followerId, followedId];
}

class UnfollowUserEvent extends FollowEvent {
  final String followerId;
  final String followedId;

  UnfollowUserEvent({
    required this.followerId,
    required this.followedId,
  });

  @override
  List<Object?> get props => [followerId, followedId];
}
