import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/entities/user_entity.dart';

class FollowEntity {
  final String id;
  final UserEntity follower;
  final UserEntity followed;

  FollowEntity({
    required this.id,
    required this.follower,
    required this.followed,
  });

  FollowEntity copyWith({
    String? id,
    UserEntity? follower,
    UserEntity? followed,
  }) {
    return FollowEntity(
      id: id ?? this.id,
      follower: follower ?? this.follower,
      followed: followed ?? this.followed,
    );
  }

  factory FollowEntity.fromModel(
      UserModel followerModel, UserModel followedModel, String followId) {
    return FollowEntity(
      id: followId,
      follower: UserEntity.fromModel(followerModel),
      followed: UserEntity.fromModel(followedModel),
    );
  }
}
