import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/domain/repositories/image_repository.dart';

class DeleteImageUseCase {
  final ImageRepository repository;

  DeleteImageUseCase(this.repository);

  Future<Either<Exception, void>> call(String id) {
    return repository.deleteImage(id);
  }
}
