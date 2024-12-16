import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthCheckingStatus extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;

  Authenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthLoading extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CreateUserSuccess extends AuthState {
  final UserModel user;

  CreateUserSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class CreateUserError extends AuthState {
  final String message;

  CreateUserError({required this.message});

  @override
  List<Object?> get props => [message];
}
