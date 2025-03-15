import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/repositories/follows_repository.dart';

class GetFollowingUseCase
    implements UseCase<Either<Failure, List<UserModel>>, String> {
  final FollowRepository repository;

  GetFollowingUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserModel>>> call(String userId) async {
    return repository.getFollowing(userId);
  }
}
