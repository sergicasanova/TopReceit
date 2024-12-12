import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import '../repositories/sign_in_repository.dart';

class SignInUserUseCase
    implements UseCase<Either<Failure, UserModel>, LoginParams> {
  final SignInRepository repository;

  SignInUserUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(LoginParams params) async {
    return repository.signIn(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
