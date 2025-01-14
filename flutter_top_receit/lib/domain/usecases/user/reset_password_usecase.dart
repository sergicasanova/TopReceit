import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import '../../repositories/sign_in_repository.dart';

class ResetPasswordUseCase {
  final SignInRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.resetPassword(email);
  }
}
