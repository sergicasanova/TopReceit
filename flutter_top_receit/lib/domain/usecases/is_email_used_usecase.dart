import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import '../repositories/sign_in_repository.dart';

class IsEmailUsedUsecase {
  final SignInRepository repository;

  IsEmailUsedUsecase(this.repository);

  Future<Either<Failure, bool>> call(String email) async {
    return await repository.isEmailUsed(email);
  }
}
