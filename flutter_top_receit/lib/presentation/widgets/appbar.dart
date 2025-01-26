import 'package:flutter/material.dart';
import 'package:flutter_top_receit/config/utils/text_utils.dart';
import 'package:flutter_top_receit/presentation/widgets/lenguage_buttons.dart'; // Importamos el widget LanguageSelector

class AppBarDefault extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) onLanguageChanged; // Función para cambiar el idioma

  const AppBarDefault({
    super.key,
    required this.scaffoldKey,
    required this.onLanguageChanged, // Recibimos la función en el constructor
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextUtil(
                  text: 'TopReceit',
                  size: 20,
                  weight: true,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
          onPressed: () {
            scaffoldKey.currentState?.openEndDrawer();
          },
        ),
      ],
    );
  }
}
