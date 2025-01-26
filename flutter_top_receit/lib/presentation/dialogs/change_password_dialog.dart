import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_top_receit/presentation/blocs/auth/auth_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.drawer_change_password),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.new_password_label),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.password_required;
                }
                return null;
              },
            ),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .register_confirm_password_label),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!
                      .register_confirm_password_required;
                } else if (value != _passwordController.text) {
                  return AppLocalizations.of(context)!
                      .register_passwords_do_not_match;
                }
                return null;
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
            if (_formKey.currentState?.validate() ?? false) {
              final newPassword = _passwordController.text;
              context
                  .read<AuthBloc>()
                  .add(UpdatePasswordEvent(password: newPassword));

              Navigator.of(context).pop();
            }
          },
          child: Text(AppLocalizations.of(context)!.accept_button),
        ),
      ],
    );
  }
}
