import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/domain/repositories/image_repository.dart';

class UploadImageUseCase {
  final ImageRepository repository;

  UploadImageUseCase(this.repository);

  Future<Either<Exception, String>> execute(dynamic file, String fileName) {
    return repository.uploadImage(file, fileName);
  }
}
