import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';

abstract class FollowRepository {
  Future<Either<Failure, List<UserModel>>> getFollowers(String userId);
  Future<Either<Failure, List<UserModel>>> getFollowing(String userId);
  Future<Either<Failure, bool>> followUser(
      String followerId, String followedId);
  Future<Either<Failure, bool>> unfollowUser(
      String followerId, String followedId);
}
