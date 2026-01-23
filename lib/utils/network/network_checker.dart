import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ptg/utils/exceptions/common_exceptions.dart';

/// A utility class to check network connectivity before making API calls.
///
/// This class uses the `connectivity_plus` package to check if the device
/// has an active internet connection. If not, it throws a [NoInternetException].
///
/// **Usage:**
/// ```dart
/// final checker = NetworkChecker();
/// await checker.checkConnectivity(); // Throws NoInternetException if offline
/// ```
class NetworkChecker {
  final Connectivity _connectivity;

  /// Creates a [NetworkChecker] instance.
  ///
  /// If [connectivity] is not provided, it defaults to [Connectivity()].
  /// This allows for easy mocking in tests.
  NetworkChecker({Connectivity? connectivity})
    : _connectivity = connectivity ?? Connectivity();

  /// Checks if the device has an active internet connection.
  ///
  /// **Throws:**
  /// - [NoInternetException] if the device is offline or has no connectivity
  ///
  /// **Returns:**
  /// - `true` if connected to the internet
  ///
  /// **Example:**
  /// ```dart
  /// try {
  ///   await networkChecker.checkConnectivity();
  ///   // Proceed with API call
  /// } catch (e) {
  ///   // Handle no internet error
  /// }
  /// ```
  Future<bool> checkConnectivity() async {
    try {
      final List<ConnectivityResult> connectivityResults = await _connectivity
          .checkConnectivity();

      // Check if any connectivity result indicates an active connection
      final hasConnection = connectivityResults.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet ||
            result == ConnectivityResult.vpn,
      );

      if (!hasConnection) {
        throw NoInternetException(
          message:
              'No internet connection available. Please check your network settings.',
        );
      }

      return true;
    } catch (e) {
      // If it's already a NoInternetException, rethrow it
      if (e is NoInternetException) {
        rethrow;
      }

      // For any other error during connectivity check, treat as no internet
      throw NoInternetException(
        message:
            'Unable to verify internet connection. Please check your network settings.',
      );
    }
  }

  /// Checks connectivity and returns a boolean instead of throwing.
  ///
  /// This is useful when you want to check connectivity without exception handling.
  ///
  /// **Returns:**
  /// - `true` if connected to the internet
  /// - `false` if offline or unable to determine connectivity
  ///
  /// **Example:**
  /// ```dart
  /// final isConnected = await networkChecker.hasConnection();
  /// if (isConnected) {
  ///   // Proceed with API call
  /// } else {
  ///   // Show offline message
  /// }
  /// ```
  Future<bool> hasConnection() async {
    try {
      final List<ConnectivityResult> connectivityResults = await _connectivity
          .checkConnectivity();

      return connectivityResults.any(
        (result) =>
            result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi ||
            result == ConnectivityResult.ethernet ||
            result == ConnectivityResult.vpn,
      );
    } catch (e) {
      // If unable to check, assume no connection
      return false;
    }
  }

  /// Returns a stream of connectivity changes.
  ///
  /// This is useful for listening to connectivity changes in real-time.
  ///
  /// **Returns:**
  /// - A stream of [List<ConnectivityResult>]
  ///
  /// **Example:**
  /// ```dart
  /// networkChecker.onConnectivityChanged.listen((results) {
  ///   final isConnected = results.any((result) =>
  ///     result == ConnectivityResult.mobile ||
  ///     result == ConnectivityResult.wifi
  ///   );
  ///   print('Connected: $isConnected');
  /// });
  /// ```
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      _connectivity.onConnectivityChanged;
}
