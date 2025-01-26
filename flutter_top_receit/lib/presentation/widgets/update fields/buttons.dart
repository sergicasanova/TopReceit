import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeButtons extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  const RecipeButtons({
    super.key,
    required this.onAccept,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton(
          onPressed: onAccept,
          child: Text(AppLocalizations.of(context)!.accept_button),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onCancel,
          child: Text(AppLocalizations.of(context)!.cancel_button),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
