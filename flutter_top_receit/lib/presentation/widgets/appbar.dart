import 'package:flutter/material.dart';
import 'package:flutter_top_receit/config/router/routes.dart';
import 'package:flutter_top_receit/config/utils/text_utils.dart';
import 'package:flutter_top_receit/presentation/widgets/lenguage_buttons.dart';

class AppBarDefault extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onLanguageChanged;
  final bool isOnMainScreen;

  const AppBarDefault({
    super.key,
    required this.scaffoldKey,
    required this.onLanguageChanged,
    required this.isOnMainScreen,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0, // Sin sombra
      title: Row(
        children: [
          LanguageSelector(onLanguageChanged: onLanguageChanged),
          Expanded(
            child: GestureDetector(
              onTap: () {
                router.go('/home');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextUtil(
                    text: 'TopRecipe',
                    size: 20,
                    weight: true,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        // Botón de menú (drawer)
        IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            scaffoldKey.currentState?.openEndDrawer();
          },
        ),
        IconButton(
          icon: Icon(
            isOnMainScreen ? Icons.arrow_forward : Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            if (isOnMainScreen) {
              router.go('/allRecipes');
            } else {
              router.go('/home');
            }
          },
        ),
      ],
    );
  }
}
