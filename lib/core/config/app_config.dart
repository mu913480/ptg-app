import 'package:flutter_dotenv/flutter_dotenv.dart';

/// App configuration class for securely managing environment variables
///
/// This class provides a centralized way to access configuration values
/// loaded from the .env file. It ensures type safety and provides
/// helpful error messages if required values are missing.
class AppConfig {
  AppConfig._(); // Private constructor to prevent instantiation

  /// Initialize the configuration by loading the .env file
  ///
  /// This should be called before accessing any configuration values.
  /// Typically called in main() before runApp().
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      throw Exception(
        'Failed to load .env file. Please ensure .env exists in the root directory.\n'
        'Error: $e',
      );
    }
  }

  /// Get Supabase URL from environment variables
  ///
  /// Throws an exception if the value is not set.
  static String get supabaseUrl {
    final url = dotenv.env['SUPABASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception(
        'SUPABASE_URL is not set in .env file. '
        'Please add SUPABASE_URL=your_supabase_url to your .env file.',
      );
    }
    return url;
  }

  /// Get Supabase anonymous key from environment variables
  ///
  /// Throws an exception if the value is not set.
  static String get supabaseAnonKey {
    final key = dotenv.env['SUPABASE_ANON_KEY'];
    if (key == null || key.isEmpty) {
      throw Exception(
        'SUPABASE_ANON_KEY is not set in .env file. '
        'Please add SUPABASE_ANON_KEY=your_supabase_anon_key to your .env file.',
      );
    }
    return key;
  }

  /// Get Google Web Client ID from environment variables
  static String get googleWebClientId {
    final key = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
    if (key == null || key.isEmpty) {
      return ''; // Or handle as required
    }
    return key;
  }

  /// Get Google iOS Client ID from environment variables
  static String get googleIosClientId {
    final key = dotenv.env['GOOGLE_IOS_CLIENT_ID'];
    if (key == null || key.isEmpty) {
      return ''; // Or handle as required
    }
    return key;
  }

  /// Get Google iOS Client ID from environment variables
  static String get mapboxAccessToken {
    final key = dotenv.env['MAPBOXACCESSTOKENSYSTEM'];
    if (key == null || key.isEmpty) {
      return ''; // Or handle as required
    }
    return key;
  }

  /// Get optional Supabase service role key (for admin operations)
  ///
  /// Returns null if not set. This should only be used in secure backend contexts,
  /// never in client-side code.
  static String? get supabaseServiceRoleKey {
    return dotenv.env['SUPABASE_SERVICE_ROLE_KEY'];
  }

  /// Check if running in debug mode
  static bool get isDebugMode {
    return dotenv.env['DEBUG']?.toLowerCase() == 'true';
  }

  /// Get any custom environment variable
  ///
  /// Returns null if the key doesn't exist.
  static String? getEnv(String key) {
    return dotenv.env[key];
  }
}
