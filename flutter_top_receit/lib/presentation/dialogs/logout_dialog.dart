import 'package:flutter/material.dart';

class LogOutUser extends StatelessWidget {
  const LogOutUser({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estas seguro de que desea cerrar sesion?'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancelar');
              },
              child: const Text('Cancelar')),
          TextButton(
              onPressed: () {
                Navigator.pop(context, 'Aceptar');
              },
              child: const Text('Aceptar'))
        ]);
  }
}
