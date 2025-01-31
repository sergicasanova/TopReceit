import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoriteRepository repository;

  GetFavoritesUseCase(this.repository);

  Future<Either<Failure, List<int>>> call(String userId) {
    return repository.getFavoritesByUserId(userId);
  }
}
