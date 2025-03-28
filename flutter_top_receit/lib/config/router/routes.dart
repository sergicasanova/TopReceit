import 'package:flutter_top_receit/domain/repositories/sign_in_repository.dart';
import 'package:flutter_top_receit/injection.dart';
import 'package:flutter_top_receit/main.dart';
import 'package:flutter_top_receit/presentation/screens/UserDetailsScreen_screen.dart';
import 'package:flutter_top_receit/presentation/screens/all_recipes_screen.dart';
import 'package:flutter_top_receit/presentation/screens/create_recipe_screen.dart';
import 'package:flutter_top_receit/presentation/screens/login_screen.dart';
import 'package:flutter_top_receit/presentation/screens/main_screen.dart';
import 'package:flutter_top_receit/presentation/screens/register_screen.dart';
import 'package:flutter_top_receit/presentation/screens/shopping_list_screen.dart';
import 'package:flutter_top_receit/presentation/screens/update_recipe_screen.dart';
import 'package:flutter_top_receit/presentation/widgets/all_recipes/view%20recipe%20details/view_recipe_details.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
      routes: [
        GoRoute(
          name: 'register',
          path: 'register',
          builder: (context, state) => const RegisterScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/allRecipes',
      builder: (context, state) => const AllRecipesScreen(),
    ),
    GoRoute(
      path: '/createRecipe',
      builder: (context, state) => const CreateRecipeScreen(),
    ),
    GoRoute(
      path: '/updateRecipe/:recipeId',
      builder: (context, state) {
        final recipeId = int.parse(state.pathParameters['recipeId'] ?? '0');
        return UpdateRecipeScreen(recipeId: recipeId);
      },
    ),
    GoRoute(
      path: '/userDetails/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return UserDetailsScreen(userId: userId);
      },
    ),
    GoRoute(
      path: '/recipeDetails/:recipeId',
      builder: (context, state) {
        final recipeId = int.parse(state.pathParameters['recipeId']!);
        final extra = state.extra as Map<String, dynamic>? ?? {};

        // Debug: Imprime los extras recibidos
        print('Extras recibidos en ruta:');
        print('comesFromUserDetails: ${extra['comesFromUserDetails']}');
        print('userId: ${extra['userId']}');

        return ViewRecipeDetailsScreen(
          recipeId: recipeId,
          comesFromUserDetails: extra['comesFromUserDetails'] as bool? ?? false,
          userId: extra['userId'] as String?,
        );
      },
    ),
    GoRoute(
      path: '/shopping-list',
      name: 'shopping-list',
      builder: (context, state) => const ShoppingListScreen(),
    ),
  ],
  redirect: (context, state) async {
    final isLoggedIn = await sl<SignInRepository>().isLoggedIn();
    if (state.matchedLocation.contains('/register')) {
      return null;
    }
    return isLoggedIn.fold((_) => '/login', (loggedIn) {
      if (loggedIn == "NO_USER" && !state.matchedLocation.contains("/login")) {
        return "/login";
      } else {
        return state.matchedLocation;
      }
    });
  },
);
