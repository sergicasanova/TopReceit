import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_top_receit/presentation/blocs/follows/follows_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/follows/follows_event.dart';
import 'package:flutter_top_receit/presentation/blocs/follows/follows_state.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';
import 'package:flutter_top_receit/presentation/widgets/drawer.dart';
import 'package:flutter_top_receit/presentation/widgets/public_user_recipes/public_recipes_list.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String? currentBackground;
  int _selectedIndex = 0;
  String? currentUserId;

  final List<String> _routes = [
    '/home',
    '/allRecipes',
    '/shopping-list',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    GoRouter.of(context).go(_routes[index]);
  }

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    _loadCurrentUserId();
    context.read<AuthBloc>().add(GetUserEvent(id: widget.userId));
    context
        .read<RecipeBloc>()
        .add(GetPublicRecipesByUserIdEvent(userId: widget.userId));
  }

  Future<void> _loadBackgroundImage() async {
    final prefs = PreferencesService();
    final bgImage = await prefs.getBackgroundImage();
    setState(() {
      currentBackground = bgImage ?? 'assets/bg9.jpeg';
    });
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('id');
    setState(() {
      currentUserId = userId;
    });

    if (userId != null) {
      context.read<FollowBloc>().add(GetFollowingEvent(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          AppLocalizations.of(context)!.user_details_title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      endDrawer: DrawerWidget(
        onBackgroundChanged: (newBackground) {
          setState(() {
            currentBackground = newBackground;
          });
        },
      ),
      body: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(currentBackground ?? 'assets/bg9.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Contenido principal
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final user = state.user;
                      if (user == null) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            AppLocalizations.of(context)!.user_data_not_found,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                          ),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.all(16),
                        margin: EdgeInsets.only(
                          top: appBarHeight + statusBarHeight + 16,
                          left: 16,
                          right: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Avatar del usuario
                            ClipOval(
                              child: user.avatar.isNotEmpty
                                  ? Image.network(
                                      user.avatar,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/icons/default_avatar.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(height: 16),
                            // Nombre del usuario
                            Text(
                              user.username,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // Preferencias del usuario
                            Text(
                              '${AppLocalizations.of(context)!.preferences_label} ${user.preferences.join(", ")}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),

                            BlocConsumer<FollowBloc, FollowState>(
                              listener: (context, followState) {
                                if (followState.actionSuccess == true) {
                                  context.read<FollowBloc>().add(
                                      GetFollowingEvent(
                                          userId: currentUserId!));
                                }
                              },
                              builder: (context, followState) {
                                final isFollowing =
                                    _isUserFollowed(followState);

                                return ElevatedButton(
                                  onPressed: () {
                                    if (currentUserId == null) {
                                      print(AppLocalizations.of(context)!
                                          .user_id_error);
                                      return;
                                    }

                                    if (isFollowing) {
                                      context
                                          .read<FollowBloc>()
                                          .add(UnfollowUserEvent(
                                            followerId: currentUserId!,
                                            followedId: widget.userId,
                                          ));
                                    } else {
                                      context
                                          .read<FollowBloc>()
                                          .add(FollowUserEvent(
                                            followerId: currentUserId!,
                                            followedId: widget.userId,
                                          ));
                                    }
                                    context.read<FollowBloc>().add(
                                        GetFollowingEvent(
                                            userId: currentUserId!));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        isFollowing ? Colors.red : Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 32, vertical: 12),
                                  ),
                                  child: Text(
                                    isFollowing
                                        ? AppLocalizations.of(context)!
                                            .unfollow_button
                                        : AppLocalizations.of(context)!
                                            .follow_button,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const RecipeListView(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home_label),
          BottomNavigationBarItem(
              icon: const Icon(Icons.public),
              label: AppLocalizations.of(context)!.public_recipes_label),
          BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart),
              label: AppLocalizations.of(context)!.shopping_list_label),
        ],
      ),
    );
  }

  bool _isUserFollowed(FollowState state) {
    if (state.following != null) {
      return state.following!.any((user) => user.id == widget.userId);
    }
    return false;
  }
}
