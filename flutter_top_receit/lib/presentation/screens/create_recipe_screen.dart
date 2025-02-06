import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/recipe/recipe_event.dart';
import 'package:flutter_top_receit/config/router/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_top_receit/presentation/functions/backgraund_sharedPref.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateRecipeScreen extends StatefulWidget {
  const CreateRecipeScreen({super.key});

  @override
  State<CreateRecipeScreen> createState() => _CreateRecipeScreenState();
}

class _CreateRecipeScreenState extends State<CreateRecipeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? userId;
  String? currentBackground;

  Future<void> _loadBackgroundImage() async {
    final prefs = PreferencesService();
    final bgImage = await prefs.getBackgroundImage();
    setState(() {
      currentBackground = bgImage ?? 'assets/bg9.jpeg';
    });
  }

  Future<void> _getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getString('id');
    setState(() {
      userId = storedUserId;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadBackgroundImage();
    _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.create_recipe_title),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(currentBackground ?? 'assets/bg9.jpeg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.title_label,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      TextField(
                        controller: _titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .create_recipe_hint_title,
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.5),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.description_label,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      TextField(
                        controller: _descriptionController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .create_recipe_hint_description,
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.5),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.image_url_label,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      TextField(
                        controller: _imageUrlController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .create_recipe_hint_image_url,
                          hintStyle: const TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.5),
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_titleController.text.isNotEmpty &&
                                  _descriptionController.text.isNotEmpty &&
                                  _imageUrlController.text.isNotEmpty &&
                                  userId != null) {
                                context.read<RecipeBloc>().add(
                                      CreateRecipeEvent(
                                        title: _titleController.text,
                                        description:
                                            _descriptionController.text,
                                        image: _imageUrlController.text,
                                        userId: userId!,
                                      ),
                                    );

                                router.go('/home');
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .recipe_fields_required)),
                                );
                              }
                            },
                            // ignore: sort_child_properties_last
                            child: Text(AppLocalizations.of(context)!
                                .create_recipe_title),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.green,
                              side: BorderSide.none,
                              elevation: 0,
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              router.go('/home');
                            },
                            // ignore: sort_child_properties_last
                            child: Text(
                                AppLocalizations.of(context)!.cancel_button),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.red,
                              side: BorderSide.none,
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
