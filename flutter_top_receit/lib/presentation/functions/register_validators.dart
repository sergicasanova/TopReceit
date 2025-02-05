// lib/presentation/validators/register_validations.dart

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_top_receit/presentation/functions/validators_function.dart';

String? emailValidator(String? value, bool? isEmailUsed, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.register_email_required;
  }
  if (!isEmailValid(value)) {
    return AppLocalizations.of(context)!.register_invalid_email;
  }
  if (isEmailUsed != null && isEmailUsed) {
    return AppLocalizations.of(context)!.register_email_taken;
  }
  return null;
}

String? usernameValidator(
    String? value, bool? isNameUsed, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.register_username_required;
  }
  if (isNameUsed != null && isNameUsed) {
    return AppLocalizations.of(context)!.register_username_taken;
  }
  return null;
}

String? passwordValidator(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.register_password_required;
  }
  if (value.length < 8) {
    return AppLocalizations.of(context)!.register_password_length;
  }
  if (!hasNumber(value)) {
    return AppLocalizations.of(context)!.register_password_number;
  }
  if (!hasUppercaseLetter(value)) {
    return AppLocalizations.of(context)!.register_password_uppercase;
  }
  if (!hasLowercaseLetter(value)) {
    return AppLocalizations.of(context)!.register_password_lowercase;
  }
  return null;
}

String? confirmPasswordValidator(
    String? value, String? password, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.register_confirm_password_required;
  }
  if (value != password) {
    return AppLocalizations.of(context)!.register_passwords_do_not_match;
  }
  return null;
}

String? preferenceValidator(String? value, BuildContext context) {
  if (value == null || value.isEmpty) {
    return AppLocalizations.of(context)!.register_preference_required;
  }
  return null;
}
