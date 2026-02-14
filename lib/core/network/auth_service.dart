import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ptg/core/utils/extensions/exception_extension.dart';
import 'package:ptg/core/network/network_checker.dart';

/// A service class for handling authentication with Supabase.
///
/// This service wraps Supabase Auth methods with network checking
/// and consistent error handling.
class AuthService {
  final SupabaseClient _supabase;
  final NetworkChecker _networkChecker;

  /// Creates an [AuthService] instance.
  ///
  /// If [supabaseClient] is not provided, it defaults to [Supabase.instance.client].
  /// If [networkChecker] is not provided, it defaults to [NetworkChecker()].
  AuthService({SupabaseClient? supabaseClient, NetworkChecker? networkChecker})
    : _supabase = supabaseClient ?? Supabase.instance.client,
      _networkChecker = networkChecker ?? NetworkChecker();

  /// Returns the currently signed-in user, if any.
  User? get currentUser => _supabase.auth.currentUser;

  /// Stream of auth state changes.
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  /// Signs in a user with email and password.
  ///
  /// Returns the [AuthResponse] on success, throws an exception on failure.
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    await _networkChecker.checkConnectivity();

    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } on Exception catch (e) {
      throw Exception(e.exceptionToString());
    }
  }

  /// Signs up a user with email and password.
  ///
  /// Returns the [AuthResponse] on success, throws an exception on failure.
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    await _networkChecker.checkConnectivity();

    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: data,
      );
      return response;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } on Exception catch (e) {
      throw Exception(e.exceptionToString());
    }
  }

  /// Signs in a user with Google OAuth.
  ///
  /// Returns true on success, throws an exception on failure.
  Future<bool> signInWithGoogle() async {
    await _networkChecker.checkConnectivity();

    try {
      /// [webClientId] is required for Google Sign-In on web and Android.
      /// You can get it from the Google Cloud Console.
      const webClientId = 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com';

      /// [iosClientId] is required for Google Sign-In on iOS.
      /// You can get it from the Google Cloud Console.
      const iosClientId = 'YOUR_IOS_CLIENT_ID.apps.googleusercontent.com';

      final googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Google ID Token not found.');
      }

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return response.user != null;
    } on AuthException catch (e) {
      throw Exception(e.message);
    } on Exception catch (e) {
      throw Exception(e.exceptionToString());
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    await _networkChecker.checkConnectivity();

    try {
      await _supabase.auth.signOut();
    } on AuthException catch (e) {
      throw Exception(e.message);
    } on Exception catch (e) {
      throw Exception(e.exceptionToString());
    }
  }
}
