import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/favorites/favorites_event.dart';
import 'package:flutter_top_receit/presentation/blocs/favorites/favorites_state.dart';

class RecipeCard extends StatelessWidget {
  final String title;
  final String description;
  final String image;
  final VoidCallback onTap;
  final int ingredientsCount;
  final int stepsCount;
  final int recipeId;
  final String userId;

  const RecipeCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.onTap,
    required this.ingredientsCount,
    required this.stepsCount,
    required this.recipeId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 5,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/icons/recipe.png',
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/icons/recipe.png', // Imagen por defecto si no hay URL
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.kitchen,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$ingredientsCount',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Row(
                          children: [
                            const Icon(
                              Icons.directions_walk,
                              size: 16,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '$stepsCount',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BlocBuilder<FavoriteBloc, FavoriteState>(
                builder: (context, state) {
                  bool isFavorite =
                      state.favoriteRecipeIds?.contains(recipeId) ?? false;
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.yellow : Colors.grey,
                    ),
                    onPressed: () {
                      if (isFavorite) {
                        context.read<FavoriteBloc>().add(RemoveFavoriteEvent(
                            userId: userId, recipeId: recipeId));
                      } else {
                        context.read<FavoriteBloc>().add(AddFavoriteEvent(
                            userId: userId, recipeId: recipeId));
                      }

                      context
                          .read<FavoriteBloc>()
                          .add(GetFavoritesEvent(userId: userId));
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
