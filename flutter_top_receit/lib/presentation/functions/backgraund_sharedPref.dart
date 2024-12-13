import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  // Guarda el fondo seleccionado en SharedPreferences
  Future<void> saveBackgroundImage(String bgImage) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('background_image', bgImage);
  }

  // Lee el fondo guardado en SharedPreferences
  Future<String?> getBackgroundImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('background_image');
  }

  Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }
}
