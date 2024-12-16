import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import '../repositories/sign_in_repository.dart';

class SignUpUseCase
    implements UseCase<Either<Failure, UserModel>, SignUpParams> {
  final SignInRepository repository;

  SignUpUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(SignUpParams params) async {
    return repository.signUp(
      params.email,
      params.password,
      params.username,
      params.avatar,
      params.preferences,
    );
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String username;
  final String avatar;
  final List<String> preferences;

  SignUpParams({
    required this.email,
    required this.password,
    required this.username,
    required this.avatar,
    required this.preferences,
  });
}
