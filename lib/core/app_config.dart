import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  const AppConfig._();

  static const _supabaseUrlDefine = String.fromEnvironment('SUPABASE_URL');
  static const _supabaseAnonKeyDefine =
      String.fromEnvironment('SUPABASE_ANON_KEY');
  static const _geminiApiKeyDefine = String.fromEnvironment('GEMINI_API_KEY');
  static const _maptilerApiKeyDefine =
      String.fromEnvironment('MAPTILER_API_KEY');
  static const _googleMapsApiKeyDefine =
      String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static const _foursquareApiKeyDefine =
      String.fromEnvironment('FOURSQUARE_API_KEY');

  static String get supabaseUrl => _read('SUPABASE_URL', _supabaseUrlDefine);
  static String get supabaseAnonKey =>
      _read('SUPABASE_ANON_KEY', _supabaseAnonKeyDefine);
  static String get geminiApiKey =>
      _read('GEMINI_API_KEY', _geminiApiKeyDefine);
  static String get maptilerApiKey =>
      _read('MAPTILER_API_KEY', _maptilerApiKeyDefine);
  static String get googleMapsApiKey =>
      _read('GOOGLE_MAPS_API_KEY', _googleMapsApiKeyDefine);
  static String get foursquareApiKey =>
      _read('FOURSQUARE_API_KEY', _foursquareApiKeyDefine);

  static bool get hasSupabaseConfig =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static Future<void> loadDotEnvForDebug() async {
    if (!kDebugMode || dotenv.isInitialized) return;

    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // .env is optional. Prefer --dart-define for production builds.
    }
  }

  static String _read(String key, String dartDefineValue) {
    if (dartDefineValue.isNotEmpty) return dartDefineValue;
    if (!dotenv.isInitialized) return '';
    return dotenv.env[key]?.trim() ?? '';
  }
}
