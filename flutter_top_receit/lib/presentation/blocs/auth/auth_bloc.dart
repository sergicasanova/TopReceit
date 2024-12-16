import 'package:bloc/bloc.dart';
import 'package:flutter_top_receit/core/use_case.dart';
import 'package:flutter_top_receit/domain/usecases/firestore/create_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/firestore/get_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/firestore/update_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/reset_password_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_in_user_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_up_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/sign_in_user_google_usecase.dart';
import 'package:flutter_top_receit/domain/usecases/logout_usecase.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignInUserUseCase signInUseCase;
  final SignInUserGoogleUseCase signInGoogleUseCase;
  final SignUpUseCase signUpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final LogoutUseCase logoutUseCase;
  final CreateUserUseCase createUserUseCase;
  final GetUserUseCase getUserUseCase;
  final UpdateUserUseCase updateUserUseCase;

  AuthBloc({
    required this.getCurrentUserUseCase,
    required this.signInUseCase,
    required this.signInGoogleUseCase,
    required this.signUpUseCase,
    required this.resetPasswordUseCase,
    required this.logoutUseCase,
    required this.createUserUseCase,
    required this.getUserUseCase,
    required this.updateUserUseCase,
  }) : super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignInEvent>(_onSignIn);
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignUpEvent>(_onSignUp);
    on<ResetPasswordEvent>(_onResetPassword);
    on<LogoutEvent>(_onLogout);
    // on<CreateUserEvent>(_onCreateUser);
    on<GetUserEvent>(_onGetUser);
    on<UpdateUserEvent>(_onUpdateUser);
  }

  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthCheckingStatus());
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInUseCase(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) => emit(AuthError(message: 'Error al iniciar sesión')),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onSignInWithGoogle(
      SignInWithGoogleEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await signInGoogleUseCase(NoParams());

    result.fold(
      (failure) =>
          emit(AuthError(message: 'Error al iniciar sesión con Google')),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await signUpUseCase(SignUpParams(
      email: event.email,
      password: event.password,
      username: event.username,
      avatar: event.avatar,
      preferences: event.preferences,
    ));

    result.fold(
      (failure) => emit(AuthError(message: 'Error al registrarse')),
      (user) async {
        final createUserResult = await createUserUseCase(user);

        createUserResult.fold(
          (failure) => emit(
              AuthError(message: 'Error al guardar los datos en Firestore')),
          (user) => emit(Authenticated(user: user)),
        );
      },
    );
  }

  Future<void> _onGetUser(GetUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await getUserUseCase(event.userId);

    result.fold(
      (failure) => emit(AuthError(message: 'Error al obtener el usuario')),
      (user) {
        if (user != null) {
          emit(Authenticated(user: user));
        } else {
          emit(AuthError(message: 'Usuario no encontrado'));
        }
      },
    );
  }

  Future<void> _onUpdateUser(
      UpdateUserEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await updateUserUseCase(event.user);

    result.fold(
      (failure) => emit(AuthError(message: 'Error al actualizar el usuario')),
      (user) => emit(Authenticated(user: user)),
    );
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await resetPasswordUseCase(ResetPasswordParams(event.email));

    result.fold(
      (failure) => emit(
          AuthError(message: 'Error al enviar correo de restablecimiento')),
      (_) => emit(AuthInitial()),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(message: 'Error al cerrar sesión')),
      (_) => emit(Unauthenticated()),
    );
  }
}
