import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RecipeForm extends StatefulWidget {
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
  RecipeFormState createState() => RecipeFormState();
}

class RecipeFormState extends State<RecipeForm> {
  dynamic imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    if (kIsWeb) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          imageFile = result.files.single.bytes;
        });
      }
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    }
  }

  Future<String?> uploadImage() async {
    if (imageFile == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('recipes/${DateTime.now().toString()}');

      final metadata = SettableMetadata(contentType: 'image/jpeg');

      if (kIsWeb) {
        await storageRef.putData(imageFile, metadata);
      } else {
        await storageRef.putFile(imageFile, metadata);
      }

      final downloadUrl = await storageRef.getDownloadURL();
      // ignore: use_build_context_synchronously
      print(
          '${AppLocalizations.of(context)!.recipe_fields_required} $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await ref.delete();
      print(AppLocalizations.of(context)!.image_delete_success);
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.imageUrlController.text);

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
            controller: widget.descriptionController,
            maxLines: 5,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.description_hint,
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
          AppLocalizations.of(context)!.image_url_label,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: pickImage,
            child: Text(AppLocalizations.of(context)!.select_new_image),
          ),
        ),
        if (imageFile != null) ...[
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.new_image_selected),
          const SizedBox(height: 8),
          kIsWeb
              ? Image.memory(
                  imageFile,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                )
              : Image.file(
                  imageFile,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ],
        const SizedBox(height: 16),
        if (widget.imageUrlController.text.isNotEmpty) ...[
          Text(AppLocalizations.of(context)!.current_image_label),
          const SizedBox(height: 8),
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
          ),
        ] else ...[
          Text(AppLocalizations.of(context)!.no_current_image),
          const SizedBox(height: 16),
          Image.asset(
            'assets/icons/recipe.png',
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
        const SizedBox(height: 32),
      ],
    );
  }
}
