import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import '../../repositories/sign_in_repository.dart';

class SignOutUserUseCase implements UseCase<void, NoParams> {
  final SignInRepository repository;
  SignOutUserUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return repository.logout();
  }
}
