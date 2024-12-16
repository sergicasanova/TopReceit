import 'package:equatable/equatable.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class SignInWithGoogleEvent extends AuthEvent {}

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

class LogoutEvent extends AuthEvent {}

class ResetPasswordEvent extends AuthEvent {
  final String email;

  ResetPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class GetUserEvent extends AuthEvent {
  final String userId;

  GetUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CreateUserEvent extends AuthEvent {
  final UserModel user;

  CreateUserEvent({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUserEvent extends AuthEvent {
  final UserModel user;

  UpdateUserEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
