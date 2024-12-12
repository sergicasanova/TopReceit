import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import '../repositories/sign_in_repository.dart';

class SignInUserGoogleUseCase
    implements UseCase<Either<Failure, UserModel>, NoParams> {
  final SignInRepository repository;

  SignInUserGoogleUseCase(this.repository);

  @override
  Future<Either<Failure, UserModel>> call(NoParams params) async {
    return repository.signInGoogle();
  }
}
