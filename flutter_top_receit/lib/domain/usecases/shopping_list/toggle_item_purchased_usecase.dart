import 'package:dartz/dartz.dart';
import 'package:flutter_top_receit/core/failure.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_item_entity.dart';
import 'package:flutter_top_receit/domain/repositories/shopping_list_repository.dart';
import 'package:flutter_top_receit/core/use_case.dart';

class ToggleItemPurchasedUseCase
    implements
        UseCase<Either<Failure, ShoppingListItemEntity>, ToggleItemParams> {
  final ShoppingListRepository repository;

  ToggleItemPurchasedUseCase(this.repository);

  @override
  Future<Either<Failure, ShoppingListItemEntity>> call(
      ToggleItemParams params) async {
    return repository.toggleItemPurchased(params.userId, params.itemId);
  }
}

class ToggleItemParams {
  final String userId;
  final String itemId;

  ToggleItemParams({required this.userId, required this.itemId});
}
