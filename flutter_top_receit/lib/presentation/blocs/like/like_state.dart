import 'package:equatable/equatable.dart';

class LikeState extends Equatable {
  final bool isLoading;
  final String? errorMessage;
  final List<String>? likeUserIds;

  const LikeState({
    this.isLoading = false,
    this.errorMessage,
    this.likeUserIds,
  });

  @override
  List<Object?> get props => [isLoading, errorMessage ?? '', likeUserIds ?? []];

  LikeState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<String>? likeUserIds,
  }) {
    return LikeState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      likeUserIds: likeUserIds ?? this.likeUserIds,
    );
  }

  factory LikeState.initial() => const LikeState();

  factory LikeState.loading() => const LikeState(isLoading: true);

  factory LikeState.success() => const LikeState();

  factory LikeState.failure(String errorMessage) =>
      LikeState(errorMessage: errorMessage);

  factory LikeState.loadedLikes(List<String> likeUserIds) =>
      LikeState(likeUserIds: likeUserIds);
}
