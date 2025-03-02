import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        Text(
          AppLocalizations.of(context)!.title_label,
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: TextField(
            controller: titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.title_hint,
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              // ignore: deprecated_member_use
              fillColor: Colors.black.withOpacity(0.5),
              border: const OutlineInputBorder(),
            ),
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
            controller: descriptionController,
            maxLines: 5,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.description_hint,
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black.withOpacity(0.5),
              border: const OutlineInputBorder(),
            ),
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
            controller: imageUrlController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.image_url_hint,
              hintStyle: const TextStyle(color: Colors.white),
              filled: true,
              fillColor: Colors.black.withOpacity(0.5),
              border: const OutlineInputBorder(),
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
