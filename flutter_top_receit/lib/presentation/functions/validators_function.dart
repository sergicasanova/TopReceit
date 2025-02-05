bool hasNumber(String value) {
  return value.contains(RegExp(r'\d'));
}

bool hasUppercaseLetter(String value) {
  return value.contains(RegExp(r'[A-Z]'));
}

bool hasLowercaseLetter(String value) {
  return value.contains(RegExp(r'[a-z]'));
}

bool isEmailValid(String value) {
  return RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  ).hasMatch(value);
}
