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

  /// Signs in a user with Google OAuth.
  ///
  /// Returns true on success, throws an exception on failure.
  Future<bool> signInWithGoogle() async {
    await _networkChecker.checkConnectivity();

    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.ptg://login-callback/',
      );
      return response;
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
