import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/entities/user_entity.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
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
  final _preferencesController = TextEditingController();
  String? _avatar;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _preferencesController.text = widget.user.preferences.join(", ");
    _avatar = widget.user.avatar;
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatar = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modificar datos del usuario'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _preferencesController,
              decoration: const InputDecoration(labelText: 'Preferences'),
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: Text(_avatar != null ? 'Avatar: $_avatar' : 'Sin avatar'),
              onTap: _pickAvatar,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final updatedUser = widget.user.copyWith(
              username: _usernameController.text,
              preferences: _preferencesController.text.split(", ").toList(),
              avatar: _avatar ?? widget.user.avatar,
            );

            final updatedUserModel = UserModel(
              id: updatedUser.id,
              email: updatedUser.email,
              username: updatedUser.username,
              avatar: updatedUser.avatar,
              preferences: updatedUser.preferences,
            );
            context
                .read<AuthBloc>()
                .add(UpdateUserEvent(user: updatedUserModel));

            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: const Text('Aceptar'),
        ),
      ],
    );
  }
}
