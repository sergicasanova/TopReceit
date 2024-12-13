import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_top_receit/presentation/dialogs/logout_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  Future<String?> _getUserEmailFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  color: Colors.deepOrangeAccent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top, bottom: 24),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          FutureBuilder<String?>(
                            future: _getUserEmailFromPreferences(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text("Error al cargar el email");
                              } else {
                                return Text(
                                  snapshot.data ?? "Usuario no registrado",
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: const EdgeInsets.only(bottom: 16),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.black),
                ),
                Icon(
                  Icons.exit_to_app,
                  color: Colors.black,
                ),
              ],
            ),
            onTap: () async {
              // Mostramos el diálogo de logout
              final resultado = await showDialog<String>(
                context: context,
                builder: (context) => const LogOutUser(),
              );
              if (!context.mounted) return;
              if (resultado == 'Aceptar') {
                context.read<AuthBloc>().add(LogoutEvent());
                context.go('/login');
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
