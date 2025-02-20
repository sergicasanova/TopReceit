import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_event.dart';
import 'package:flutter_top_receit/presentation/blocs/like/like_state.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/like/like_bloc.dart'; // Importamos el LikeBloc
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';
import 'package:flutter_top_receit/presentation/widgets/all_recipes/all_recipe_list.dart';
import 'package:flutter_top_receit/presentation/widgets/drawer.dart';
import 'package:flutter_top_receit/presentation/widgets/appbar.dart';

class AllRecipesScreen extends StatefulWidget {
  const AllRecipesScreen({super.key});

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  String? currentBackground;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    _getRecipes();
  }

  Future<void> _loadBackgroundImage() async {
    final prefs = PreferencesService();
    final bgImage = await prefs.getBackgroundImage();
    setState(() {
      currentBackground = bgImage ?? 'assets/bg9.jpeg';
    });
  }

  void _getRecipes() {
    context.read<RecipeBloc>().add(GetAllRecipesEvent());
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarDefault(
        scaffoldKey: scaffoldKey,
        onLanguageChanged: (languageCode) {
          Locale locale = Locale(languageCode);
          context.read<LanguageBloc>().add(ChangeLanguageEvent(locale));
        },
        isOnMainScreen: false,
      ),
      endDrawer: DrawerWidget(
        onBackgroundChanged: (newBackground) {
          setState(() {
            currentBackground = newBackground;
          });
        },
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
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
          BlocListener<LikeBloc, LikeState>(
            listener: (context, state) {
              if (state.isUpdated) {
                context.read<RecipeBloc>().add(GetAllRecipesEvent());
              }
            },
            child: const Padding(
              padding: EdgeInsets.only(top: 100),
              child: AllRecipeList(),
            ),
          ),
        ],
      ),
    );
  }
}
