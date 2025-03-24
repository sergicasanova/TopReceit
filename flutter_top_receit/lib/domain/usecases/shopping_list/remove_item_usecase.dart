import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/shopping_list_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class RemoveItemUseCase
    implements UseCase<Either<Failure, void>, RemoveItemParams> {
  final ShoppingListRepository repository;

  RemoveItemUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveItemParams params) async {
    return repository.removeItem(params.userId, params.itemId);
  }
}

class RemoveItemParams {
  final String userId;
  final String itemId;

  RemoveItemParams({required this.userId, required this.itemId});
}
