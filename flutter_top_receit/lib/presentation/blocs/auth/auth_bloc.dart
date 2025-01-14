import 'package:bloc/bloc.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/domain/usecases/user/get_current_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/get_user_api_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/is_email_used_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/is_name_used_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/reset_password_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/sign_in_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/sign_out_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/sign_up_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/sign_in_user_google_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/update_password_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/user/update_user_usecase.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SigninUserUseCase signInUseCase;
  final SignOutUserUseCase signOutUserUseCase;
  final SigninUserGoogleUseCase signInGoogleUseCase;
  final SignUpUseCase signUpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final IsEmailUsedUsecase isEmailUsedUseCase;
  final IsNameUsedUsecase isNameUsedUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final UpdatePasswordUseCase updatePasswordUseCase;
  final GetUserUseCase getUserUseCase;

  AuthBloc(
      this.getCurrentUserUseCase,
      this.signInUseCase,
      this.signOutUserUseCase,
      this.signInGoogleUseCase,
      this.signUpUseCase,
      this.resetPasswordUseCase,
      this.isEmailUsedUseCase,
      this.isNameUsedUseCase,
      this.updateUserUseCase,
      this.updatePasswordUseCase,
      this.getUserUseCase)
      : super(AuthState.initial()) {
    on<IsEmailUserUsed>((event, emit) async {
      emit(const AuthState(isLoading: true));
      final emailResult = await isEmailUsedUseCase(event.email);
      final nameResult = await isNameUsedUseCase(event.username);
      emit(AuthState(
        isLoading: false,
        isEmailUsed: emailResult.fold((_) => null, (isUsed) => isUsed),
        isNameUsed: nameResult.fold((_) => null, (isUsed) => isUsed),
      ));
    });

    on<SignInEvent>((event, emit) async {
      emit(AuthState.loading());
      final result = await signInUseCase(LoginParams(
        email: event.email,
        password: event.password,
      ));
      result.fold(
        (failure) => emit(AuthState.failure("Fallo al realizar el login")),
        (_) => emit(AuthState.success(event.email)),
      );
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthState.loading());
      final result = await signUpUseCase(SignUpParams(
        email: event.email,
        password: event.password,
        username: event.username,
        avatar: event.avatar,
        preferences: event.preferences,
      ));
      result.fold(
        (failure) => emit(AuthState.failure("Fallo al realizar el registro")),
        (_) => emit(AuthState.success(event.email)),
      );
    });

    on<CheckAuthStatusEvent>((event, emit) async {
      final result = await getCurrentUserUseCase(NoParams());
      result.fold(
        (failure) =>
            emit(AuthState.failure("Fallo al verificar la autenticación")),
        (user) => emit(AuthState.isLoggedIn(user)),
      );
    });

    on<LogoutEvent>((event, emit) async {
      final result = await signOutUserUseCase(NoParams());
      result.fold(
          (failure) => emit(AuthState.failure("Fallo al realizar el logout")),
          (_) => emit(AuthState.initial()));
    });

    on<SignInWithGoogleEvent>((event, emit) async {
      emit(AuthState.loading());
      final result = await signInGoogleUseCase(LoginParamsGoogle());
      result.fold(
        (failure) => emit(AuthState.failure("Fallo al realizar el login")),
        (_) => emit(AuthState.success('')),
      );
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(AuthState.loading());
      final result = await resetPasswordUseCase(event.email);
      result.fold(
        (failure) =>
            emit(AuthState.failure("Fallo al realizar la recuperacion")),
        (_) => emit(AuthState.success('')),
      );
    });

    on<UpdatePasswordEvent>((event, emit) async {
      emit(AuthState.loading());
      final result = await updatePasswordUseCase(
          UpdatePasswordParams(password: event.password));

      if (result == true) {
        emit(AuthState.success("Contraseña actualizada"));
      } else {
        emit(AuthState.failure("Fallo al actualizar la contraseña"));
      }
    });

    on<GetUserEvent>((event, emit) async {
      emit(AuthState.loading());
      final result = await getUserUseCase.call(event.id);

      result.fold(
        (failure) =>
            emit(AuthState.failure("Fallo al realizar la recuperación")),
        (user) {
          emit(AuthState.isLoggedIn(user));
        },
      );
    });

    on<UpdateUserEvent>((event, emit) async {
      emit(AuthState.loading());
      final result =
          await updateUserUseCase(UpdateUserParams(user: event.user));

      result.fold(
        (failure) =>
            emit(AuthState.failure("Fallo al realizar la actualización")),
        (_) async {
          final result = await getUserUseCase.call(event.user.id);

          result.fold(
            (failure) => emit(
                AuthState.failure("Fallo al obtener los datos del usuario")),
            (user) {
              emit(AuthState.isLoggedIn(user));
            },
          );
        },
      );
    });
  }
}
