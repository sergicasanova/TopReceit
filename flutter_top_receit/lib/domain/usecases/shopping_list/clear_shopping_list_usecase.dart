import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/repositories/shopping_list_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class ClearShoppingListUseCase
    implements UseCase<Either<Failure, void>, String> {
  final ShoppingListRepository repository;

  ClearShoppingListUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String userId) async {
    return repository.clearShoppingList(userId);
  }
}
