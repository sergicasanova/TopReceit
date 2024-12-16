import 'package:flutter/material.dart';

class PreferencesSelector extends StatefulWidget {
  final TextEditingController preferencesController;
  final String? Function(String?)? validator;

  const PreferencesSelector({
    Key? key,
    required this.preferencesController,
    required this.validator,
  }) : super(key: key);

  @override
  _PreferencesSelectorState createState() => _PreferencesSelectorState();
}

class _PreferencesSelectorState extends State<PreferencesSelector> {
  final List<String> preferences = [
    'Carne',
    'Pescado',
    'Verduras',
    'Dulce',
    'Salado',
  ];

  String? selectedPreference;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: preferences.map((preference) {
        return RadioListTile<String>(
          title: Text(preference),
          value: preference,
          groupValue: selectedPreference,
          onChanged: (String? value) {
            setState(() {
              selectedPreference = value;
              widget.preferencesController.text = value ?? '';
            });
          },
        );
      }).toList(),
    );
  }
}
