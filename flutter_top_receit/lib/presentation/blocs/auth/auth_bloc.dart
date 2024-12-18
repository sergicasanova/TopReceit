import 'package:bloc/bloc.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/is_email_used_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/is_name_used_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/reset_password_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_in_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_out_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_in_user_google_usecase.dart';

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

  AuthBloc(
      this.getCurrentUserUseCase,
      this.signInUseCase,
      this.signOutUserUseCase,
      this.signInGoogleUseCase,
      this.signUpUseCase,
      this.resetPasswordUseCase,
      this.isEmailUsedUseCase,
      this.isNameUsedUseCase)
      : super(AuthState.initial()) {
    on<IsEmailUserUsed>((event, emit) async {
      emit(AuthState(isLoading: true));
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
        (id) => emit(AuthState.isLoggedIn(id)),
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
  }
}
