import 'package:ptg/utils/exceptions/common_exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

extension ReadableException on Exception {
  String exceptionToString() {
    if (this is NoInternetException) {
      return 'Sorry! No internet connection available. Please check your network settings.';
    }

    if (this is AuthApiException) {
      return _handleAuthApiException(this as AuthApiException);
    }

    if (this is ApiException) {
      return 'API request failed: ${(this as ApiException).message}';
    }
    if (this is DatabaseException) {
      return 'Database operation failed: ${(this as DatabaseException).message}';
    }
    if (this is CacheException) {
      return 'Cache operation failed: ${(this as CacheException).message}';
    }
    if (this is SocketException) {
      return 'Socket operation failed: ${(this as SocketException).message}';
    }
    return 'An unexpected error occurred: ${toString()}';
  }

  /// Handles Supabase AuthApiException and returns user-friendly error messages
  String _handleAuthApiException(AuthApiException exception) {
    // Check for specific error codes in the message
    // invalid_credentials - Wrong email or password
    if (exception.code == 'invalid_credentials') {
      return 'Wrong email or password. Please check your credentials and try again.';
    }

    // email_not_confirmed - User hasn't verified their email yet
    if (exception.code == 'email_not_confirmed') {
      return 'Please verify your email address before signing in. Check your inbox for the confirmation email.';
    }

    // user_not_found - No account exists with that email
    if (exception.code == 'user_not_found') {
      return 'No account exists with this email address. Please sign up first.';
    }

    // user_already_exists - Email is already registered
    if (exception.code == 'user_already_exists') {
      return 'An account with this email already exists. Please sign in instead.';
    }

    // weak_password - Password doesn't meet requirements
    if (exception.code == 'weak_password') {
      return 'Password is too weak. Please use at least 6 characters.';
    }

    // invalid_email - Email format is invalid
    if (exception.code == 'invalid_email') {
      return 'Please enter a valid email address.';
    }

    return 'Authentication failed. Please check your credentials and try again.';
  }
}
