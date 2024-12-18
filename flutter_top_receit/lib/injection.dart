import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_top_receit/data/datasources/firebase_auth_datasource.dart';
import 'package:flutter_top_receit/data/datasources/firestore_datasource.dart';
import 'package:flutter_top_receit/data/repositories/sing_in_repository_impl.dart';
import 'package:flutter_top_receit/domain/repositories/sign_in_repository.dart';
import 'package:flutter_top_receit/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/is_email_used_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/is_name_used_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/reset_password_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_in_user_google_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_in_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_out_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // Blocs
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()),
  );

  // Instancia de Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Fuentes de datos
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(auth: sl<FirebaseAuth>()),
  );
  sl.registerLazySingleton<FirestoreDataSource>(
    () => FirestoreDataSource(),
  );

  // Repositorios
  sl.registerLazySingleton<SignInRepository>(
    () => SignInRepositoryImpl(sl<FirebaseAuthDataSource>(), sl(), sl()),
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

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
