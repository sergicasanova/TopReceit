class AuthState {
  final bool isLoading;
  final String? email;
  final String? errorMessage;
  final bool? isEmailUsed;
  final bool? isNameUsed;
  final String? id;

  const AuthState({
    this.isLoading = false,
    this.email,
    this.errorMessage,
    this.isEmailUsed,
    this.isNameUsed,
    this.id,
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
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      isEmailUsed: isEmailUsed ?? this.isEmailUsed,
      isNameUsed: isNameUsed ?? this.isNameUsed,
      id: id ?? this.id,
    );
  }

  factory AuthState.initial() => const AuthState();

  factory AuthState.loading() => const AuthState(isLoading: true);

  factory AuthState.success(String email) => AuthState(email: email);

  factory AuthState.isLoggedIn(String id) => AuthState(id: id);

  factory AuthState.failure(String errorMessage) =>
      AuthState(errorMessage: errorMessage);
}
