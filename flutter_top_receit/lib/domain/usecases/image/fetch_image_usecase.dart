import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/domain/entities/image_entity.dart';
import 'package:flutter_top_receit/domain/repositories/image_repository.dart';

class FetchImagesUseCase {
  final ImageRepository repository;

  FetchImagesUseCase(this.repository);

  Future<Either<Exception, List<ImageEntity>>> call() {
    return repository.fetchImages();
  }
}
