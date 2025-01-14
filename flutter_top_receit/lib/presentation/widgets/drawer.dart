import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_top_receit/presentation/dialogs/backgraund_selection_dialog.dart';
import 'package:flutter_top_receit/presentation/dialogs/change_password_dialog.dart';
import 'package:flutter_top_receit/presentation/dialogs/logout_dialog.dart';
import 'package:flutter_top_receit/presentation/dialogs/UserConfigurationDialog.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidget extends StatelessWidget {
  final Function(String) onBackgroundChanged;

  const DrawerWidget({super.key, required this.onBackgroundChanged});

  Future<String?> _getUserEmailFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<AuthBloc>(context);

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            accountName: FutureBuilder<String?>(
              future: _getUserEmailFromPreferences(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Cargando...");
                } else if (snapshot.hasError) {
                  return const Text("Error al cargar el email");
                } else {
                  return Text(
                    snapshot.data ?? "Usuario no registrado",
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  );
                }
              },
            ),
            accountEmail: Text(
              userBloc.state.user?.username ?? 'Usuario',
              style: const TextStyle(color: Colors.white),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/bg9.jpeg'),
            ),
          ),

          // Drawer menu options
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.lightBlue),
                  title: const Text('Configuración'),
                  onTap: () {
                    final user = userBloc.state.user;

                    if (user != null) {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            UserConfigurationDialog(user: user),
                      );
                    } else {
                      print('User not found!');
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.lock, color: Colors.lightBlue),
                  title: const Text('Cambiar Contraseña'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => const ChangePasswordDialog(),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.wallpaper, color: Colors.lightBlue),
                  title: const Text('Cambiar fondo de pantalla'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BackgroundSelectionDialog(
                          onBackgroundChanged: onBackgroundChanged,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.red),
            title: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
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
