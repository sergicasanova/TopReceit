import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LogOutUser extends StatelessWidget {
  const LogOutUser({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout_title),
        content: Text(AppLocalizations.of(context)!.logout_confirmation),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancelar');
              },
              child: Text(AppLocalizations.of(context)!.cancel_button)),
          TextButton(
              onPressed: () {
                Navigator.pop(context, 'Aceptar');
              },
              child: Text(AppLocalizations.of(context)!.accept_button))
        ]);
  }
}
