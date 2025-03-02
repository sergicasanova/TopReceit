import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/entities/user_entity.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class UserConfigurationDialog extends StatefulWidget {
  final UserEntity user;

  const UserConfigurationDialog({super.key, required this.user});

  @override
  _UserConfigurationDialogState createState() =>
      _UserConfigurationDialogState();
}

class _UserConfigurationDialogState extends State<UserConfigurationDialog> {
  final _usernameController = TextEditingController();
  final _avatarController = TextEditingController();
  List<String> _selectedPreferences = [];

  final List<String> preferences = [
    'Carne',
    'Pescado',
    'Verduras',
    'Dulce',
    'Salado',
  ];

  dynamic _avatarFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _selectedPreferences = List.from(widget.user.preferences);
    _avatarController.text = widget.user.avatar;
  }

  Future<void> _pickAvatar() async {
    if (kIsWeb) {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null) {
        setState(() {
          _avatarFile = result.files.single.bytes;
        });
      }
    } else {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _avatarFile = File(pickedFile.path);
        });
      }
    }
  }

  Future<String?> _uploadAvatar(String userId) async {
    if (_avatarFile == null) return null;

    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('avatars/${DateTime.now().toString()}');

      final metadata = SettableMetadata(contentType: 'image/jpeg');

      if (kIsWeb) {
        await storageRef.putData(_avatarFile, metadata);
      } else {
        await storageRef.putFile(_avatarFile, metadata);
      }

      final downloadUrl = await storageRef.getDownloadURL();
      print('Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Error uploading avatar: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.modify_user_title),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.register_username_label),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedPreferences.isNotEmpty
                  ? _selectedPreferences[0]
                  : null,
              onChanged: (newValue) {
                setState(() {
                  if (newValue != null) {
                    _selectedPreferences = [newValue];
                  }
                });
              },
              items: preferences.map((preference) {
                return DropdownMenuItem<String>(
                  value: preference,
                  child: Text(preference),
                );
              }).toList(),
              decoration: InputDecoration(
                labelText:
                    AppLocalizations.of(context)!.register_preferences_label,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _avatarController,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.avatar_url_label),
              onChanged: (url) {
                setState(() {
                  _avatarController.text = url;
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickAvatar,
              child: const Text('Seleccionar nuevo avatar'),
            ),
            if (_avatarFile != null) ...[
              const Text('Avatar seleccionado'),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(AppLocalizations.of(context)!.cancel_button),
        ),
        TextButton(
          onPressed: () async {
            String? avatarUrl = _avatarController.text;
            if (_avatarFile != null) {
              final uploadedUrl = await _uploadAvatar(widget.user.id);
              if (uploadedUrl != null) {
                avatarUrl = uploadedUrl;
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error uploading avatar')),
                );
                return;
              }
            }

            final updatedUser = widget.user.copyWith(
              username: _usernameController.text,
              preferences: _selectedPreferences,
              avatar: avatarUrl,
            );

            final updatedUserModel = UserModel(
              id: updatedUser.id,
              email: updatedUser.email,
              username: updatedUser.username,
              avatar: updatedUser.avatar,
              preferences: updatedUser.preferences,
            );

            // ignore: use_build_context_synchronously
            context
                .read<AuthBloc>()
                .add(UpdateUserEvent(user: updatedUserModel));

            // ignore: use_build_context_synchronously
            Navigator.pop(context);
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.accept_button),
        ),
      ],
    );
  }
}
