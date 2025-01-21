import 'package:flutter/material.dart';

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
          child: const Text('Aceptar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: onCancel,
          child: const Text('Cancelar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
