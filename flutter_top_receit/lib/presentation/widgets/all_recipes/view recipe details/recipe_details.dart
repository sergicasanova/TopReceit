import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final TextEditingController imageUrlController;

  const RecipeDetailsScreen({
    super.key,
    required this.titleController,
    required this.descriptionController,
    required this.imageUrlController,
  });

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.title_label,
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: widget.titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.title_hint,
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black.withOpacity(0.5),
              border: OutlineInputBorder(),
            ),
            enabled: false,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.description_label,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: widget.descriptionController,
            maxLines: 5,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.description_hint,
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black.withOpacity(0.5),
              border: const OutlineInputBorder(),
            ),
            enabled: false, // Deshabilitar para solo mostrar el contenido
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppLocalizations.of(context)!.image_url_label,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: widget.imageUrlController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.image_url_hint,
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black.withOpacity(0.5),
              border: OutlineInputBorder(),
            ),
            enabled: false, // Deshabilitar para solo mostrar el contenido
          ),
        ),
        const SizedBox(height: 32),
        if (widget.imageUrlController.text.isNotEmpty)
          Image.network(
            widget.imageUrlController.text,
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
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/icons/recipe.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          )
        else
          Image.asset(
            'assets/icons/recipe.png',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        const SizedBox(height: 32),
      ],
    );
  }
}
