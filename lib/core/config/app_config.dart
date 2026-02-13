import 'dart:io';

class AppConfig {
  // Android Emulator loopback for localhost
  static const String baseUrlAndroid = 'http://10.0.2.2:8000';
  // iOS/Windows/Mac localhost
  static const String baseUrlLocal = 'http://127.0.0.1:8000';

  // Placeholder for Railway URL
  static const String baseUrlProd = 'https://fiorenzo.up.railway.app';

  // Toggle this for Dev/Prod switch
  static const bool isDev = true;

  static String get baseUrl {
    if (!isDev) return baseUrlProd;
    try {
      if (Platform.isAndroid) return baseUrlAndroid;
    } catch (e) {
      // Platform check might fail on web, but we are mobile/desktop
    }
    return baseUrlLocal;
  }
}
