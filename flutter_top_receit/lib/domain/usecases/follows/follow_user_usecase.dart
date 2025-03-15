import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/domain/repositories/follows_repository.dart';

class FollowUserUseCase
    implements UseCase<Either<Failure, bool>, FollowParams> {
  final FollowRepository repository;

  FollowUserUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(FollowParams params) async {
    return repository.followUser(params.followerId, params.followedId);
  }
}

class FollowParams {
  final String followerId;
  final String followedId;

  FollowParams({required this.followerId, required this.followedId});
}
