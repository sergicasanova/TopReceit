import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_top_receit/data/datasources/firebase_auth_datasource.dart';
import 'package:flutter_top_receit/data/datasources/firestore_datasource.dart';
import 'package:flutter_top_receit/data/repositories/firestore_repository_impl.dart';
import 'package:flutter_top_receit/data/repositories/sing_in_repository_impl.dart';
import 'package:flutter_top_receit/domain/repositories/firestore_repository.dart';
import 'package:flutter_top_receit/domain/repositories/sign_in_repository.dart';
import 'package:flutter_top_receit/domain/usecases/firestore/create_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/firestore/get_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/firestore/update_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/logout_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/reset_password_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_in_user_google_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_in_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void configureDependencies() {
  // Blocs
  sl.registerFactory(
    () => AuthBloc(
      getCurrentUserUseCase: sl(),
      signInUseCase: sl(),
      signInGoogleUseCase: sl(),
      signUpUseCase: sl(),
      resetPasswordUseCase: sl(),
      logoutUseCase: sl(),
      createUserUseCase: sl(),
      getUserUseCase: sl(),
      updateUserUseCase: sl(),
    ),
  );

  // Instancia de Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);

  // Firestore DataSource
  sl.registerLazySingleton<FirestoreDataSource>(
    () => FirestoreDataSource(firestore: FirebaseFirestore.instance),
  );

  // Fuentes de datos
  sl.registerLazySingleton<FirebaseAuthDataSource>(
    () => FirebaseAuthDataSource(
      auth: sl<FirebaseAuth>(),
    ),
  );

  // Repositorios
  sl.registerLazySingleton<SignInRepository>(
    () => SignInRepositoryImpl(sl<FirebaseAuthDataSource>()),
  );
  sl.registerLazySingleton<FirestoreRepository>(
    () =>
        FirestoreRepositoryImpl(firestoreDataSource: sl<FirestoreDataSource>()),
  );

  // Casos de uso
  sl.registerLazySingleton<SignInUserUseCase>(
    () => SignInUserUseCase(sl()),
  );
  sl.registerLazySingleton<SignInUserGoogleUseCase>(
    () => SignInUserGoogleUseCase(sl()),
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
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl()),
  );
  sl.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(sl()),
  );
  sl.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateUserUseCase>(
    () => UpdateUserUseCase(sl()),
  );
}
