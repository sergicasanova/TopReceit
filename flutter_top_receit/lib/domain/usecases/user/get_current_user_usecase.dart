import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/domain/entities/user_entity.dart';
import '../../repositories/sign_in_repository.dart';

class GetCurrentUserUseCase
    implements UseCase<Either<Failure, UserEntity>, NoParams> {
  final SignInRepository repository;
  GetCurrentUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return repository.isLoggedIn();
  }
}
