import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/domain/entities/shopping_list_entity.dart';
import 'package:flutter_top_receit/domain/usecases/shopping_list/add_recipe_ingredients_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/shopping_list/clear_shopping_list_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/shopping_list/get_shopping_list_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/shopping_list/remove_item_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/shopping_list/toggle_item_purchased_usecase.dart';

import 'shopping_list_event.dart';
import 'shopping_list_state.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {
  final GetShoppingListUseCase getShoppingListUseCase;
  final AddRecipeIngredientsUseCase addRecipeIngredientsUseCase;
  final RemoveItemUseCase removeItemUseCase;
  final ClearShoppingListUseCase clearShoppingListUseCase;
  final ToggleItemPurchasedUseCase toggleItemPurchasedUseCase;

  ShoppingListBloc(
    this.getShoppingListUseCase,
    this.addRecipeIngredientsUseCase,
    this.removeItemUseCase,
    this.clearShoppingListUseCase,
    this.toggleItemPurchasedUseCase,
  ) : super(ShoppingListState.initial()) {
    on<GetShoppingListEvent>((event, emit) async {
      emit(ShoppingListState.loading());
      final result = await getShoppingListUseCase.call(event.userId);

      List<String> ingredients = [];

      ingredients = result.fold(
          (failure) => [],
          (shoppingList) =>
              shoppingList.items.map((item) => item.ingredientName).toList());
      ingredients = ingredients.toSet().toList();

      result.fold(
        (failure) => emit(
            ShoppingListState.failure("Fallo al obtener la lista de compras")),
        (shoppingList) =>
            emit(ShoppingListState.loaded(shoppingList, ingredients)),
      );
    });

    // initState(){
    //  getSopplintsEvents }

// BlocBuilder(){
// loading => Ciruclar }
// return
    // List Vieew
    // items: state.ingredientes
    // itembuilder(index, context)
    // String ingrediente = state.ingreidintes[index]
    // List<ShoppingListItemEntity> items = state.shoppingList.items.where((item) => item.ingredientName == ingrediente).toList();
    // return Column(childrne[...items.map((item) => Row(children: [Text(item.ingredientName), Text(item.quantity.toString])...

// PATATA
// _______________________________
// 1 KG
// 3 UDS.

// CEBOLLA
// _______________________________
// 1 KG

    on<AddRecipeIngredientsEvent>((event, emit) async {
      emit(ShoppingListState.loading());
      final result = await addRecipeIngredientsUseCase.call(
        AddIngredientsParams(userId: event.userId, recipeId: event.recipeId),
      );

      result.fold(
        (failure) =>
            emit(ShoppingListState.failure("Fallo al añadir ingredientes")),
        (shoppingList) {
          emit(ShoppingListState.loaded(shoppingList, state.ingredients));
          add(GetShoppingListEvent(userId: event.userId));
        },
      );
    });

    on<RemoveItemEvent>((event, emit) async {
      emit(ShoppingListState.loading());
      final result = await removeItemUseCase.call(
        RemoveItemParams(userId: event.userId, itemId: event.itemId),
      );

      result.fold(
        (failure) =>
            emit(ShoppingListState.failure("Fallo al eliminar el ítem")),
        (_) => add(GetShoppingListEvent(userId: event.userId)),
      );
    });

    on<ClearShoppingListEvent>((event, emit) async {
      emit(ShoppingListState.loading());
      final result = await clearShoppingListUseCase.call(event.userId);
      result.fold(
        (failure) =>
            emit(ShoppingListState.failure("Fallo al vaciar la lista")),
        (_) => emit(ShoppingListState.cleared()),
      );
    });

    on<ToggleItemPurchasedEvent>((event, emit) async {
      emit(ShoppingListState.loading());
      final result = await toggleItemPurchasedUseCase.call(
        ToggleItemParams(userId: event.userId, itemId: event.itemId),
      );

      // List<ShoppingListItemEntity> shoppingList = List.from(state.shoppingList);

      // int index = shoppingList.indexWhere((item) => item.id == event.itemId);

      // shoppingList[index] = result.fold(
      //   (failure) => state.shoppingList[index],
      //   (item) => item,
      // );

      result.fold(
        (failure) =>
            emit(ShoppingListState.failure("Fallo al actualizar el ítem")),
        (item) {
          emit(ShoppingListState.itemUpdated(item));
          add(GetShoppingListEvent(userId: event.userId));
        },
      );
    });
  }
}
