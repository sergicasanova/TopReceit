import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/domain/entities/image_entity.dart';

abstract class ImageRepository {
  Future<Either<Exception, List<ImageEntity>>> fetchImages();
  Future<Either<Exception, String>> uploadImage(dynamic file, String fileName);
  Future<Either<Exception, void>> deleteImage(String imageUrl);
}
