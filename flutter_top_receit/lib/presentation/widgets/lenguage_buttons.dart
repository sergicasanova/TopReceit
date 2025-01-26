import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  final Function(String) onLanguageChanged;

  LanguageSelector({required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.language, color: Colors.white),
      onSelected: (String languageCode) {
        onLanguageChanged(languageCode);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'en',
          child: Text(AppLocalizations.of(context)!.language_english),
        ),
        PopupMenuItem<String>(
          value: 'es',
          child: Text(AppLocalizations.of(context)!.language_spanish),
        ),
        PopupMenuItem<String>(
          value: 'fr',
          child: Text(AppLocalizations.of(context)!.language_french),
        ),
      ],
    );
  }
}
