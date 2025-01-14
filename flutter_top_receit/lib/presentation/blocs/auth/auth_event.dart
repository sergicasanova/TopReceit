import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String avatar;
  final List<String> preferences;

  SignUpEvent({
    required this.email,
    required this.password,
    required this.username,
    required this.avatar,
    required this.preferences,
  });

  @override
  List<Object?> get props => [email, password, username, avatar, preferences];
}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  ResetPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class GetUserEvent extends AuthEvent {
  final String id;

  GetUserEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class CreateUserEvent extends AuthEvent {
  final UserModel user;

  CreateUserEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class IsEmailUserUsed extends AuthEvent {
  final String email;
  final String username;

  IsEmailUserUsed({required this.email, required this.username});

  @override
  List<Object?> get props => [email, username];
}

class UpdateUserEvent extends AuthEvent {
  final UserModel user;

  UpdateUserEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdatePasswordEvent extends AuthEvent {
  final String password;

  UpdatePasswordEvent({required this.password});

  @override
  List<Object?> get props => [password];
}

class SignInWithGoogleEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
