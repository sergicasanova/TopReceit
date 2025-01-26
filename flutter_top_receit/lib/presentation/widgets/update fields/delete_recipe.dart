import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<String?> showDeleteRecipeDialog(BuildContext context) async {
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
            AppLocalizations.of(context)!.delete_recipe_confirmation_title),
        content: Text(
            AppLocalizations.of(context)!.delete_recipe_confirmation_content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop("cancelar");
            },
            child: Text(AppLocalizations.of(context)!.cancel_button),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop("eliminar");
            },
            child: Text(AppLocalizations.of(context)!.delete_button),
          ),
        ],
      );
    },
  );
}
