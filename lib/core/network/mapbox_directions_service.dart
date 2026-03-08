import 'dart:convert';
import 'dart:io';

import 'package:ptg/core/config/app_config.dart';
import 'package:ptg/features/stops/models/stop_model.dart';

/// Service for fetching actual road routes from the Mapbox Directions API v5.
class MapboxDirectionsService {
  static const String _baseUrl = 'https://api.mapbox.com/directions/v5/mapbox';
  static const int _maxWaypoints = 25;

  /// Fetches the road route geometry between the given [stops].
  ///
  /// Returns a list of `[longitude, latitude]` coordinate pairs representing
  /// the actual road path. Uses the `driving` profile by default.
  ///
  /// If the API call fails or there are fewer than 2 stops, returns an empty list.
  Future<List<List<double>>> getRouteCoordinates(List<Stop> stops) async {
    if (stops.length < 2) return [];

    final accessToken = AppConfig.mapboxAccessToken;
    if (accessToken.isEmpty) return [];

    try {
      // Handle Mapbox's 25-waypoint limit by chunking
      if (stops.length <= _maxWaypoints) {
        return await _fetchRoute(stops, accessToken);
      }

      // For more than 25 waypoints, fetch in overlapping chunks
      final allCoordinates = <List<double>>[];
      for (int i = 0; i < stops.length - 1; i += _maxWaypoints - 1) {
        final end = (i + _maxWaypoints).clamp(0, stops.length);
        final chunk = stops.sublist(i, end);
        final coords = await _fetchRoute(chunk, accessToken);

        // Avoid duplicating the junction point between chunks
        if (allCoordinates.isNotEmpty && coords.isNotEmpty) {
          coords.removeAt(0);
        }
        allCoordinates.addAll(coords);
      }
      return allCoordinates;
    } catch (_) {
      return [];
    }
  }

  Future<List<List<double>>> _fetchRoute(
    List<Stop> stops,
    String accessToken,
  ) async {
    final coordinates = stops
        .map((s) => '${s.longitude},${s.latitude}')
        .join(';');

    final uri = Uri.parse(
      '$_baseUrl/walking/$coordinates?geometries=geojson&overview=full&access_token=$accessToken',
    );

    final client = HttpClient();
    try {
      final request = await client.getUrl(uri);
      final response = await request.close();

      if (response.statusCode != 200) return [];

      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;

      final routes = json['routes'] as List?;
      if (routes == null || routes.isEmpty) return [];

      final geometry = routes[0]['geometry'] as Map<String, dynamic>?;
      if (geometry == null) return [];

      final coords = geometry['coordinates'] as List;
      return coords
          .map<List<double>>(
            (dynamic c) => [(c[0] as num).toDouble(), (c[1] as num).toDouble()],
          )
          .toList();
    } finally {
      client.close();
    }
  }
}
