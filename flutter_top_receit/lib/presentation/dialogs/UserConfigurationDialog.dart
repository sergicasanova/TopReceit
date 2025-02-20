import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/data/models/user_model.dart';
import 'package:flutter_top_receit/domain/entities/user_entity.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.user.username;
    _selectedPreferences = List.from(
        widget.user.preferences); // Initialize with user's preferences
    _avatarController.text = widget.user.avatar;
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
          onPressed: () {
            final updatedUser = widget.user.copyWith(
              username: _usernameController.text,
              preferences: _selectedPreferences,
              avatar: _avatarController.text,
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
          child: Text(AppLocalizations.of(context)!.accept_button),
        ),
      ],
    );
  }
}
