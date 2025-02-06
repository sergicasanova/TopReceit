import 'package:equatable/equatable.dart';

class LikeState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<String>? likeUserIds;
  final bool
      isUpdated; // Nueva propiedad para indicar si el like fue actualizado

  const LikeState({
    this.isLoading = false,
    this.errorMessage,
    this.likeUserIds,
    this.isUpdated = false, // Inicialmente no está actualizado
  });

  @override
  List<Object?> get props =>
      [isLoading, errorMessage ?? '', likeUserIds ?? [], isUpdated];

  LikeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<String>? likeUserIds,
    bool? isUpdated, // Permite cambiar si el like fue actualizado
  }) {
    return LikeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      likeUserIds: likeUserIds ?? this.likeUserIds,
      isUpdated: isUpdated ?? this.isUpdated, // Si es actualizado, lo refleja
    );
  }

  factory LikeState.initial() => const LikeState();

  factory LikeState.loading() => const LikeState(isLoading: true);

  factory LikeState.success() => const LikeState();

  factory LikeState.failure(String errorMessage) =>
      LikeState(errorMessage: errorMessage);

  factory LikeState.loadedLikes(List<String> likeUserIds) =>
      LikeState(likeUserIds: likeUserIds);

  factory LikeState.likeUpdated() => LikeState(
      isUpdated: true); // Nuevo estado que indica que el like fue actualizado
}
