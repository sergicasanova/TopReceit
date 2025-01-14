import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/domain/usecases/ingredient/create_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/ingredient/delete_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/ingredient/get_all_ingredient_usecase.dart';
import 'package:flutter_top_receit/presentation/blocs/ingredient/ingredient_event.dart';
import 'package:flutter_top_receit/presentation/blocs/ingredient/ingredient_state.dart';

class IngredientBloc extends Bloc<IngredientEvent, IngredientState> {
  final CreateIngredientUseCase createIngredientUseCase;
  final GetAllIngredientsUseCase getAllIngredientsUseCase;
  final DeleteIngredientUseCase deleteIngredientUseCase;

  IngredientBloc(
    this.createIngredientUseCase,
    this.getAllIngredientsUseCase,
    this.deleteIngredientUseCase,
  ) : super(const IngredientState()) {
    on<GetAllIngredientsEvent>((event, emit) async {
      emit(IngredientState.loading());
      final result = await getAllIngredientsUseCase.call(name: event.name);
      result.fold(
        (failure) =>
            emit(IngredientState.failure("Fallo al cargar los ingredientes")),
        (ingredients) => emit(IngredientState.loaded(ingredients)),
      );
    });

    on<CreateIngredientEvent>((event, emit) async {
      emit(IngredientState.loading());
      final result = await createIngredientUseCase.call(event.ingredient);
      result.fold(
        (failure) =>
            emit(IngredientState.failure("Fallo al crear el ingrediente")),
        (ingredient) {
          emit(IngredientState.created(ingredient));
          add(GetAllIngredientsEvent());
        },
      );
    });

    on<DeleteIngredientEvent>((event, emit) async {
      emit(IngredientState.loading());
      final result = await deleteIngredientUseCase.call(event.id);
      result.fold(
        (failure) =>
            emit(IngredientState.failure("Fallo al eliminar el ingrediente")),
        (_) => emit(IngredientState.deleted()),
      );
    });
  }
}
