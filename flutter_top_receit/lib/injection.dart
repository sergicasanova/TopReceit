import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_top_receit/data/datasources/firebase_auth_datasource.dart';
import 'package:flutter_top_receit/data/datasources/firestore_datasource.dart';
import 'package:flutter_top_receit/data/datasources/ingredient_api_datasource.dart';
import 'package:flutter_top_receit/data/datasources/user_api_datasource.dart';
import 'package:flutter_top_receit/data/repositories/ingredient_repository_impl.dart';
import 'package:flutter_top_receit/data/repositories/sing_in_repository_impl.dart';
import 'package:flutter_top_receit/domain/repositories/ingredient_repository.dart';
import 'package:flutter_top_receit/domain/repositories/sign_in_repository.dart';
import 'package:flutter_top_receit/domain/usecases/ingredient/create_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/ingredient/delete_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/ingredient/get_all_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/get_current_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/get_user_api_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/is_email_used_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/is_name_used_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/reset_password_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/sign_in_user_google_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/sign_in_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/sign_out_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/sign_up_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/update_password_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/update_user_usecase.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/ingredient/ingredient_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final GetIt sl = GetIt.instance;

void configureDependencies() async {
  // Blocs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
        sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );
  sl.registerFactory<IngredientBloc>(() => IngredientBloc(sl(), sl(), sl()));

  // Instancia de Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Fuentes de datos
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<FirestoreDataSource>(
    () => FirestoreDataSource(),
  );
  sl.registerLazySingleton<UserApiDataSource>(
    () => UserApiDataSource(sl()),
  );
  sl.registerLazySingleton<IngredientApiDataSource>(
      () => IngredientApiDataSource(sl()));

  // Repositorios
  sl.registerLazySingleton<SignInRepository>(
    () => SignInRepositoryImpl(sl<FirebaseAuthDataSource>(), sl(), sl(), sl()),
  );
  sl.registerLazySingleton<IngredientRepository>(
    () => IngredientRepositoryImpl(sl()),
  );

  // Casos de uso
  sl.registerLazySingleton<SigninUserUseCase>(
    () => SigninUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignOutUserUseCase>(
    () => SignOutUserUseCase(sl()),
  );
  sl.registerLazySingleton<SigninUserGoogleUseCase>(
    () => SigninUserGoogleUseCase(sl()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignUpUseCase>(
    () => SignUpUseCase(sl()),
  );
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl()),
  );
  sl.registerLazySingleton<IsEmailUsedUsecase>(
    () => IsEmailUsedUsecase(sl()),
  );
  sl.registerLazySingleton<IsNameUsedUsecase>(
    () => IsNameUsedUsecase(sl()),
  );
  sl.registerLazySingleton<UpdatePasswordUseCase>(
    () => UpdatePasswordUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(sl()),
  );
  sl.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(sl()));

  //Ingredient
  sl.registerLazySingleton<CreateIngredientUseCase>(
    () => CreateIngredientUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllIngredientsUseCase>(
    () => GetAllIngredientsUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteIngredientUseCase>(
    () => DeleteIngredientUseCase(sl()),
  );

  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
