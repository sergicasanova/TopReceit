import 'package:flutter_top_receit/domain/entities/user_entity.dart';

class AuthState {
  final bool isLoading;
  final String? email;
  final String? errorMessage;
  final bool? isEmailUsed;
  final bool? isNameUsed;
  final String? id;
  final UserEntity? user;

  const AuthState({
    this.isLoading = false,
    this.email,
    this.errorMessage,
    this.isEmailUsed,
    this.isNameUsed,
    this.id,
    this.user,
  });

  List<Object?> get props => [
        isLoading,
        email ?? "",
        errorMessage ?? "",
        isEmailUsed ?? false,
        isNameUsed ?? false,
        id ?? ""
      ];

  AuthState copyWith({
    bool? isLoading,
    String? email,
    String? errorMessage,
    bool? isEmailUsed,
    bool? isNameUsed,
    String? id,
    UserEntity? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmailUsed: isEmailUsed ?? this.isEmailUsed,
      isNameUsed: isNameUsed ?? this.isNameUsed,
      id: id ?? this.id,
      user: user ?? this.user,
    );
  }

  factory AuthState.initial() => const AuthState();

  factory AuthState.loading() => const AuthState(isLoading: true);

  factory AuthState.success(String email) => AuthState(email: email);

  // factory AuthState.isLoggedIn(String id) => AuthState(id: id);

  factory AuthState.isLoggedIn(UserEntity user) => AuthState(user: user);

  factory AuthState.failure(String errorMessage) =>
      AuthState(errorMessage: errorMessage);
}
