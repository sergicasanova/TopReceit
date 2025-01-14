import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import '../../repositories/sign_in_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class UpdateUserUseCase
    implements UseCase<Either<Failure, UserModel>, UpdateUserParams> {
  final SignInRepository repository;

  UpdateUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(UpdateUserParams params) async {
    return repository.updateUser(params.user);
  }
}

class UpdateUserParams {
  final UserModel user;

  UpdateUserParams({required this.user});
}
