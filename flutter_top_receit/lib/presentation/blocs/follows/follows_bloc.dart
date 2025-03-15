import 'package:bloc/bloc.dart';
import 'package:flutter_top_receit/domain/entities/user_entity.dart';
import 'package:flutter_top_receit/domain/usecases/follows/follow_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/follows/get_followers_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/follows/get_following_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/follows/unfollow_user_usecase.dart';
import 'package:flutter_top_receit/presentation/blocs/follows/follows_event.dart';
import 'package:flutter_top_receit/presentation/blocs/follows/follows_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final GetFollowersUseCase getFollowersUseCase;
  final GetFollowingUseCase getFollowingUseCase;
  final FollowUserUseCase followUserUseCase;
  final UnfollowUserUseCase unfollowUserUseCase;

  FollowBloc(
    this.getFollowersUseCase,
    this.getFollowingUseCase,
    this.followUserUseCase,
    this.unfollowUserUseCase,
  ) : super(FollowState.initial()) {
    // Obtener seguidores
    on<GetFollowersEvent>((event, emit) async {
      emit(FollowState.loading());
      final result = await getFollowersUseCase(event.userId);

      result.fold(
        (failure) => emit(
            FollowState.failure("Fallo al obtener la lista de seguidores")),
        (followers) {
          // Convertir List<UserModel> a List<UserEntity>
          final followersEntities = followers
              .map((userModel) => UserEntity.fromModel(userModel))
              .toList();
          emit(FollowState.followersLoaded(followersEntities));
        },
      );
    });

    // Obtener usuarios seguidos
    on<GetFollowingEvent>((event, emit) async {
      emit(FollowState.loading());
      final result = await getFollowingUseCase(event.userId);

      result.fold(
        (failure) => emit(FollowState.failure(
            "Fallo al obtener la lista de usuarios seguidos")),
        (following) {
          // Convertir List<UserModel> a List<UserEntity>
          final followingEntities = following
              .map((userModel) => UserEntity.fromModel(userModel))
              .toList();
          emit(FollowState.followingLoaded(followingEntities));
        },
      );
    });

    // Seguir a un usuario
    on<FollowUserEvent>((event, emit) async {
      emit(FollowState.loading());
      final result = await followUserUseCase(
        FollowParams(
          followerId: event.followerId,
          followedId: event.followedId,
        ),
      );

      result.fold(
        (failure) => emit(FollowState.failure("Fallo al seguir al usuario")),
        (_) => emit(FollowState.actionSuccess()),
      );
    });

    // Dejar de seguir a un usuario
    on<UnfollowUserEvent>((event, emit) async {
      emit(FollowState.loading());
      final result = await unfollowUserUseCase(
        UnFollowParams(
          followerId: event.followerId,
          followedId: event.followedId,
        ),
      );

      result.fold(
        (failure) =>
            emit(FollowState.failure("Fallo al dejar de seguir al usuario")),
        (_) => emit(FollowState.actionSuccess()),
      );
    });
  }
}
