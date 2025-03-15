import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/datasources/follows_datasource.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/repositories/follows_repository.dart';

class FollowRepositoryImpl implements FollowRepository {
  final FollowApiDataSource followApiDataSource;

  FollowRepositoryImpl(this.followApiDataSource);

  @override
  Future<Either<Failure, List<UserModel>>> getFollowers(String userId) async {
    try {
      final followers = await followApiDataSource.getFollowers(userId);
      return Right(followers);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Error al obtener los seguidores: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getFollowing(String userId) async {
    try {
      final following = await followApiDataSource.getFollowing(userId);
      return Right(following);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Error al obtener la lista de siguiendo: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> followUser(
      String followerId, String followedId) async {
    try {
      final result =
          await followApiDataSource.followUser(followerId, followedId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Error al seguir al usuario: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> unfollowUser(
      String followerId, String followedId) async {
    try {
      final result =
          await followApiDataSource.unfollowUser(followerId, followedId);
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(
          message: 'Error al dejar de seguir al usuario: ${e.toString()}'));
    }
  }
}
