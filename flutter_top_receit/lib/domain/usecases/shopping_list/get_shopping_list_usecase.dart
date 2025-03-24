import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_entity.dart';
import 'package:flutter_top_receit/domain/repositories/shopping_list_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class GetShoppingListUseCase
    implements UseCase<Either<Failure, ShoppingListEntity>, String> {
  final ShoppingListRepository repository;

  GetShoppingListUseCase(this.repository);

  @override
  Future<Either<Failure, ShoppingListEntity>> call(String userId) async {
    return repository.getShoppingList(userId);
  }
}
