import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/domain/entities/user_entity.dart';

class FollowState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<UserEntity>? followers;
  final List<UserEntity>? following; // Lista de usuarios seguidos
  final bool? actionSuccess; // Indica éxito al seguir/dejar de seguir

  const FollowState({
    this.isLoading = false,
    this.errorMessage,
    this.followers,
    this.following,
    this.actionSuccess,
  });

  @override
  List<Object?> get props => [
        isLoading,
        errorMessage ?? "",
        followers ?? [],
        following ?? [],
        actionSuccess ?? false,
      ];

  FollowState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<UserEntity>? followers,
    List<UserEntity>? following,
    bool? actionSuccess,
  }) {
    return FollowState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      actionSuccess: actionSuccess ?? this.actionSuccess,
    );
  }

  factory FollowState.initial() => const FollowState();

  factory FollowState.loading() => const FollowState(isLoading: true);

  factory FollowState.followersLoaded(List<UserEntity> followers) =>
      FollowState(
        followers: followers,
      );

  factory FollowState.followingLoaded(List<UserEntity> following) =>
      FollowState(
        following: following,
      );

  factory FollowState.actionSuccess() => const FollowState(actionSuccess: true);

  factory FollowState.failure(String errorMessage) =>
      FollowState(errorMessage: errorMessage);
}
