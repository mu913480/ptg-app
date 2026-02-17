import 'dart:async';
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
      final googleSignIn = GoogleSignIn.instance;

      final completer = Completer<AuthResponse>();

      /// Listen for the sign-in event to capture the ID and access tokens.
      final subscription = googleSignIn.authenticationEvents.listen((
        event,
      ) async {
        if (event is GoogleSignInAuthenticationEventSignIn) {
          try {
            final auth = event.user.authentication;
            final idToken = auth.idToken;
            print(idToken);
            if (idToken == null) {
              completer.completeError(Exception('Google ID Token not found.'));
              print("Google ID Token not found.");
              return;
            }

            /// Retrieve the access token via the authorization client.
            final authorization = await event.user.authorizationClient
                .authorizationForScopes([
                  "https://www.googleapis.com/auth/userinfo.email",
                  "email",
                ]);
            final accessToken = authorization?.accessToken;
            print(accessToken);

            final response = await _supabase.auth.signInWithIdToken(
              provider: OAuthProvider.google,
              idToken: idToken,
              accessToken: accessToken,
            );
            print("response: $response");
            completer.complete(response);
          } catch (e) {
            print(e.toString());
            completer.completeError(e);
          }
        }
      });

      /// Trigger the authentication flow.
      await googleSignIn.authenticate();

      final response = await completer.future;

      /// Cleanup the subscription.
      await subscription.cancel();

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
