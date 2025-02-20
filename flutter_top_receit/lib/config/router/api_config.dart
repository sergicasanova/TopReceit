import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    if (kIsWeb) {
      // return 'http://192.168.1.20:8080';
      return 'http://localhost:3000';
    } else {
      return dotenv.env['BASE_URL'] ?? 'http://192.168.1.20:8080';
    }
  }
}
