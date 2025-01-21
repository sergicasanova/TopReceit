import 'package:flutter/material.dart';

class RecipeForm extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController imageUrlController;

  const RecipeForm({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.imageUrlController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Título',
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Ingresa el nuevo título de la receta',
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black.withOpacity(0.5),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Descripción',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: descriptionController,
            maxLines: 5,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Ingresa la descripción de la receta',
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black.withOpacity(0.5),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'URL de la Imagen',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: imageUrlController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Ingresa la nueva URL de la imagen',
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black.withOpacity(0.5),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 32),
        if (imageUrlController.text.isNotEmpty)
          Image.network(
            imageUrlController.text,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              }
            },
          ),
        const SizedBox(height: 32),
      ],
    );
  }
}
