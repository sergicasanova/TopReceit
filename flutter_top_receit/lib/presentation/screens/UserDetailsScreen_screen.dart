import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_state.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/lenguage/lenguage_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_state.dart';
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';
import 'package:flutter_top_receit/presentation/widgets/appbar.dart';
import 'package:flutter_top_receit/presentation/widgets/drawer.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  String? currentBackground;

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();

    // Lanzar evento para obtener los datos del usuario
    context.read<AuthBloc>().add(GetUserEvent(id: widget.userId));

    // Lanzar evento para obtener las recetas del usuario
    context
        .read<RecipeBloc>()
        .add(GetRecipesByUserIdEvent(userId: widget.userId));
  }

  Future<void> _loadBackgroundImage() async {
    final prefs = PreferencesService();
    final bgImage = await prefs.getBackgroundImage();
    setState(() {
      currentBackground = bgImage ?? 'assets/bg9.jpeg';
    });
  }

  void _onLanguageChanged(String languageCode) {
    Locale locale = Locale(languageCode);
    context.read<LanguageBloc>().add(ChangeLanguageEvent(locale));
  }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black, // Fondo negro
        elevation: 0, // Sin sombra para mantener el diseño limpio
        iconTheme: const IconThemeData(color: Colors.white), // Íconos blancos
        title: const Text(
          "Detalles del Usuario",
          style: TextStyle(color: Colors.white), // Texto blanco
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
                  // Encabezado del usuario
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final user = state.user;
                      if (user == null) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            "No se encontraron datos del usuario.",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        );
                      }

                      return Container(
                        padding: const EdgeInsets.all(16),
                        margin: EdgeInsets.only(
                          top: appBarHeight +
                              statusBarHeight +
                              16, // Dinámico debajo del AppBar
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
                              'Preferencias: ${user.preferences.join(", ")}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Aquí se implementará la lógica para seguir al usuario
                                print('Seguir al usuario: ${user.id}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, // Fondo azul
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Bordes redondeados
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                              ),
                              child: const Text(
                                "Seguir",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Lista de recetas del usuario
                  BlocBuilder<RecipeBloc, RecipeState>(
                    builder: (context, state) {
                      if (state.recipes == null || state.recipes!.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Este usuario no tiene recetas públicas.",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.recipes!.length,
                        itemBuilder: (context, index) {
                          final recipe = state.recipes![index];

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            color: Colors.white.withOpacity(0.9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: recipe.image!.isNotEmpty
                                    ? Image.network(
                                        recipe.image!,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        'assets/icons/recipe.png',
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                              title: Text(
                                recipe.title ?? "Sin título",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                recipe.description ?? "Sin descripción",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
