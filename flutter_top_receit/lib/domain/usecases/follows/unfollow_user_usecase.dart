import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/domain/repositories/follows_repository.dart';

class UnfollowUserUseCase
    implements UseCase<Either<Failure, bool>, UnFollowParams> {
  final FollowRepository repository;

  UnfollowUserUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(UnFollowParams params) async {
    return repository.unfollowUser(params.followerId, params.followedId);
  }
}

class UnFollowParams {
  final String followerId;
  final String followedId;

  UnFollowParams({required this.followerId, required this.followedId});
}
