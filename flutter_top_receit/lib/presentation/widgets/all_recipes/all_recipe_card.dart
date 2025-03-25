import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/like/like_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/like/like_event.dart';
import 'package:flutter_top_receit/presentation/screens/UserDetailsScreen_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllRecipeCard extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final String userAvatar;
  final String userName;
  final VoidCallback onTap;
  final int ingredientsCount;
  final int stepsCount;
  final int recipeId;
  final String userId;
  final List<String> likeUserIds;
  final String? loggedUserId;

  const AllRecipeCard({
    super.key,
    required this.title,
    required this.description,
    required this.image,
    required this.userAvatar,
    required this.userName,
    required this.onTap,
    required this.ingredientsCount,
    required this.stepsCount,
    required this.recipeId,
    required this.userId,
    required this.likeUserIds,
    required this.loggedUserId,
  });

  @override
  State<AllRecipeCard> createState() => _AllRecipeCardState();
}

class _AllRecipeCardState extends State<AllRecipeCard> {
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (!snapshot.hasData) {
          return const Text("No se ha encontrado el ID de usuario.");
        }
        bool hasLiked = widget.likeUserIds.contains(widget.loggedUserId);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 5,
          child: InkWell(
            onTap: () {
              widget.onTap();
              widget.likeUserIds.add(widget.loggedUserId!);
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: widget.image.isNotEmpty
                        ? Image.network(
                            widget.image,
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
                            'assets/icons/recipe.png',
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
                          widget.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          widget.description,
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
                                  '${widget.ingredientsCount}',
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
                                  '${widget.stepsCount}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navegar hacia la nueva pantalla con el router
                          context.go('/userDetails/${widget.userId}', extra: {
                            'userName': widget.userName,
                            'userAvatar': widget.userAvatar
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: widget.userAvatar.isNotEmpty
                              ? Image.network(
                                  widget.userAvatar,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/bg9.jpeg',
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/bg9.jpeg',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Text(
                        widget.userName,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      IconButton(
                        icon: Icon(
                          hasLiked ? Icons.favorite : Icons.favorite_border,
                          color: hasLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          if (widget.loggedUserId != null) {
                            if (hasLiked) {
                              context.read<LikeBloc>().add(RemoveLikeEvent(
                                  userId: widget.loggedUserId!,
                                  recipeId: widget.recipeId));
                            } else {
                              context.read<LikeBloc>().add(GiveLikeEvent(
                                  userId: widget.loggedUserId!,
                                  recipeId: widget.recipeId));
                            }
                          }
                        },
                      ),
                      Text(
                        '${widget.likeUserIds.length} likes',
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
