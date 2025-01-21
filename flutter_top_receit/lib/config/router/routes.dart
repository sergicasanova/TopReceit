import 'package:flutter_top_receit/domain/repositories/sign_in_repository.dart';
import 'package:flutter_top_receit/injection.dart';
import 'package:flutter_top_receit/presentation/screens/create_recipe_screen.dart';
import 'package:flutter_top_receit/presentation/screens/login_screen.dart';
import 'package:flutter_top_receit/presentation/screens/main_screen.dart';
import 'package:flutter_top_receit/presentation/screens/register_screen.dart';
import 'package:flutter_top_receit/presentation/screens/update_recipe_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/login/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const MainScreen()),
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
  ],
  redirect: (context, state) async {
    final isLoggedIn = await sl<SignInRepository>().isLoggedIn();
    return isLoggedIn.fold((_) => '/login', (loggedIn) {
      if (loggedIn == "NO_USER" && !state.matchedLocation.contains("/login")) {
        return "/login";
      } else {
        return state.matchedLocation;
      }
    });
  },
);
