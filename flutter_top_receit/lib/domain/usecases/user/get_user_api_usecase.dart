import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/user_entity.dart';
import 'package:flutter_top_receit/domain/repositories/sign_in_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class GetUserUseCase implements UseCase<Either<Failure, UserEntity>, String> {
  final SignInRepository repository;

  GetUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(String idUser) async {
    return repository.getUser(idUser);
  }
}
