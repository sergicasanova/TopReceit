import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_top_receit/data/datasources/favorites_api_datasource.dart';
import 'package:flutter_top_receit/data/datasources/files_firebase_datasource.dart';
import 'package:flutter_top_receit/data/datasources/firebase_auth_datasource.dart';
import 'package:flutter_top_receit/data/datasources/firestore_datasource.dart';
import 'package:flutter_top_receit/data/datasources/follows_datasource.dart';
import 'package:flutter_top_receit/data/datasources/ingredient_api_datasource.dart';
import 'package:flutter_top_receit/data/datasources/like_api_datasource.dart';
import 'package:flutter_top_receit/data/datasources/recipe_api_datasource.dart';
import 'package:flutter_top_receit/data/datasources/recipe_ingredient_api_datasource.dart';
import 'package:flutter_top_receit/data/datasources/steps_api_datasource.dart';
import 'package:flutter_top_receit/data/datasources/user_api_datasource.dart';
import 'package:flutter_top_receit/data/repositories/favorites_repository_impl.dart';
import 'package:flutter_top_receit/data/repositories/follows_repository_impl.dart';
import 'package:flutter_top_receit/data/repositories/image_repository_impl.dart';
import 'package:flutter_top_receit/data/repositories/ingredient_repository_impl.dart';
import 'package:flutter_top_receit/data/repositories/like_repository_impl.dart';
import 'package:flutter_top_receit/data/repositories/recipe_ingredient_repository_impl.dart';
import 'package:flutter_top_receit/data/repositories/recipe_repository_impl.dart';
import 'package:flutter_top_receit/data/repositories/sing_in_repository_impl.dart';
import 'package:flutter_top_receit/data/repositories/steps_repository_impl.dart';
import 'package:flutter_top_receit/domain/repositories/favorites_repository.dart';
import 'package:flutter_top_receit/domain/repositories/follows_repository.dart';
import 'package:flutter_top_receit/domain/repositories/image_repository.dart';
import 'package:flutter_top_receit/domain/repositories/ingredient_repository.dart';
import 'package:flutter_top_receit/domain/repositories/like_repository.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_ingredient_repository.dart';
import 'package:flutter_top_receit/domain/repositories/recipe_repository.dart';
import 'package:flutter_top_receit/domain/repositories/sign_in_repository.dart';
import 'package:flutter_top_receit/domain/repositories/steps_repository.dart';
import 'package:flutter_top_receit/domain/usecases/favorites/add_favorite_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/favorites/get_favorites_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/favorites/remove_favorite_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/follows/follow_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/follows/get_followers_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/follows/get_following_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/follows/unfollow_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/image/delete_image_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/image/fetch_image_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/image/upload_image_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/ingredient/create_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/ingredient/delete_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/ingredient/get_all_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/like/get_likes_by_recipe_id_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/like/give_like_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/like/remove_like_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/create_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/delete_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/get_all_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/get_public_recipes_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/get_recipe_by_id_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/get_recipe_by_user_id_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe/update_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe_ingredient/create_recipe_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe_ingredient/delete_recipe_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe_ingredient/get_all_ingredients_for_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe_ingredient/get_ingredient_by_id_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/recipe_ingredient/update_recipe_ingredient_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/steps/create_step_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/steps/delete_step_by_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/steps/delete_step_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/steps/get_steps_by_recipe_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/steps/update_steps_usecase.dart';
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
import 'package:flutter_top_receit/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/follows/follows_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/ingredient/ingredient_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/like/like_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe_ingredient/recipe_ingredient_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/steps/steps_bloc.dart';
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
  sl.registerFactory<RecipeBloc>(
      () => RecipeBloc(sl(), sl(), sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<RecipeIngredientBloc>(
      () => RecipeIngredientBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<StepBloc>(() => StepBloc(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory<LanguageBloc>(() => LanguageBloc(sl()));
  sl.registerFactory<FavoriteBloc>(() => FavoriteBloc(sl(), sl(), sl()));
  sl.registerFactory<LikeBloc>(() => LikeBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory<FollowBloc>(() => FollowBloc(sl(), sl(), sl(), sl()));

  // Instancia de Firebase Auth
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

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
  sl.registerLazySingleton<RecipeApiDataSource>(
    () => RecipeApiDataSource(sl()),
  );
  sl.registerLazySingleton<RecipeIngredientApiDataSource>(
    () => RecipeIngredientApiDataSource(sl()),
  );
  sl.registerLazySingleton<StepsApiDataSource>(
    () => StepsApiDataSource(sl()),
  );
  sl.registerLazySingleton<FavoriteApiDataSource>(
    () => FavoriteApiDataSource(sl()),
  );
  sl.registerLazySingleton<LikeApiDataSource>(
    () => LikeApiDataSource(sl()),
  );
  sl.registerLazySingleton<FirebaseStorageDataSource>(
    () => FirebaseStorageDataSourceImpl(storage: sl()),
  );
  sl.registerLazySingleton<FollowApiDataSource>(
    () => FollowApiDataSource(sl()),
  );

  // Repositorios
  sl.registerLazySingleton<SignInRepository>(
    () => SignInRepositoryImpl(sl<FirebaseAuthDataSource>(), sl(), sl(), sl()),
  );
  sl.registerLazySingleton<IngredientRepository>(
    () => IngredientRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<StepsRepository>(
    () => StepsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<RecipeIngredientRepository>(
    () => RecipeIngredientRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<FavoriteRepository>(
    () => FavoriteRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<LikeRepository>(
    () => LikeRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ImageRepository>(
    () => ImageRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<FollowRepository>(
    () => FollowRepositoryImpl(sl()),
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

  //recipe
  sl.registerLazySingleton<CreateRecipeUseCase>(
    () => CreateRecipeUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllRecipesUseCase>(
    () => GetAllRecipesUseCase(sl()),
  );
  sl.registerLazySingleton<GetRecipeByIdUseCase>(
    () => GetRecipeByIdUseCase(sl()),
  );
  sl.registerLazySingleton<GetRecipesByUserIdUseCase>(
    () => GetRecipesByUserIdUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateRecipeUseCase>(
    () => UpdateRecipeUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteRecipeUseCase>(
    () => DeleteRecipeUseCase(sl()),
  );
  sl.registerLazySingleton<GetPublicRecipesUseCase>(
    () => GetPublicRecipesUseCase(sl()),
  );

  //recipe_ingredient
  sl.registerLazySingleton<CreateRecipeIngredientUseCase>(
    () => CreateRecipeIngredientUseCase(sl()),
  );
  sl.registerLazySingleton<GetAllIngredientsForRecipeUseCase>(
    () => GetAllIngredientsForRecipeUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateRecipeIngredientUseCase>(
    () => UpdateRecipeIngredientUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteRecipeIngredientUseCase>(
    () => DeleteRecipeIngredientUseCase(sl()),
  );
  sl.registerLazySingleton<GetIngredientByIdUseCase>(
    () => GetIngredientByIdUseCase(sl()),
  );

  //steps
  sl.registerLazySingleton<CreateStepUseCase>(
    () => CreateStepUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteStepByIdUseCase>(
    () => DeleteStepByIdUseCase(sl()),
  );
  sl.registerLazySingleton<UpdateStepUseCase>(
    () => UpdateStepUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteStepUseCase>(
    () => DeleteStepUseCase(sl()),
  );
  sl.registerLazySingleton<GetStepsByRecipeUseCase>(
    () => GetStepsByRecipeUseCase(sl()),
  );

  //favorite
  sl.registerLazySingleton<AddFavoriteUseCase>(
    () => AddFavoriteUseCase(sl()),
  );
  sl.registerLazySingleton<RemoveFavoriteUseCase>(
    () => RemoveFavoriteUseCase(sl()),
  );
  sl.registerLazySingleton<GetFavoritesUseCase>(
    () => GetFavoritesUseCase(sl()),
  );

  //like
  sl.registerLazySingleton<GiveLikeUseCase>(
    () => GiveLikeUseCase(sl()),
  );
  sl.registerLazySingleton<RemoveLikeUseCase>(
    () => RemoveLikeUseCase(sl()),
  );
  sl.registerLazySingleton<GetLikesByRecipeIdUseCase>(
    () => GetLikesByRecipeIdUseCase(sl()),
  );

  //image
  sl.registerLazySingleton(() => FetchImagesUseCase(sl()));
  sl.registerLazySingleton(() => UploadImageUseCase(sl()));
  sl.registerLazySingleton(() => DeleteImageUseCase(sl()));

  // Casos de Uso para Follow
  sl.registerLazySingleton<GetFollowersUseCase>(
    () => GetFollowersUseCase(sl()),
  );
  sl.registerLazySingleton<GetFollowingUseCase>(
    () => GetFollowingUseCase(sl()),
  );
  sl.registerLazySingleton<FollowUserUseCase>(
    () => FollowUserUseCase(sl()),
  );
  sl.registerLazySingleton<UnfollowUserUseCase>(
    () => UnfollowUserUseCase(sl()),
  );

  sl.registerLazySingleton(() => http.Client());
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
}
