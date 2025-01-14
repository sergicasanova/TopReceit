import 'package:flutter_top_receit/core/use_case.dart';
import '../../repositories/sign_in_repository.dart';

class UpdatePasswordUseCase implements UseCase<bool, UpdatePasswordParams> {
  final SignInRepository repository;

  UpdatePasswordUseCase(this.repository);

  @override
  Future<bool> call(UpdatePasswordParams params) async {
    final result = await repository.updatePassword(params.password);

    return result.fold(
      (failure) {
        throw Exception(failure.message);
      },
      (success) => success,
    );
  }
}

class UpdatePasswordParams {
  final String password;

  UpdatePasswordParams({required this.password});
}
