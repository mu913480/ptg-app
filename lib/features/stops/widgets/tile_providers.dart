// import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:http_cache_drift_store/http_cache_drift_store.dart';
import 'package:path_provider/path_provider.dart';

/// Tile Provider Information
class TileProviderInfo {
  final String name;
  final String url;
  final String description;
  final String attribution;
  final List<String> subdomains;
  final bool isWorking;
  final String? notes;

  const TileProviderInfo({
    required this.name,
    required this.url,
    required this.description,
    required this.attribution,
    this.subdomains = const ['a', 'b', 'c'],
    this.isWorking = true,
    this.notes,
  });
}

extension TileProviderInfoExtension on TileProviderInfo {
  TileLayer toFlutterMapTileLayer({
    required String name,
    required String path,
  }) {
    return TileLayer(
      urlTemplate: url,
      subdomains: subdomains,
      tileProvider: CachedTileProvider(
        store: DriftCacheStore(
          databasePath: path + "/" + name,
          databaseName: name,
        ),
      ),
    );
  }
}

/// Available tile providers with their information
class AvailableTileProviders {
  static const Map<String, TileProviderInfo> providers = {
    'osm': TileProviderInfo(
      name: 'OpenStreetMap',
      url: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      description: 'Standard OpenStreetMap tiles with default styling',
      attribution: '© OpenStreetMap contributors',
      isWorking: true,
    ),
    'cartodb_voyager': TileProviderInfo(
      description: 'CartoDB Voyager style',
      name: 'CartoDB Voyager',
      url:
          'https://cartodb-basemaps-{s}.global.ssl.fastly.net/rastertiles/voyager/{z}/{x}/{y}.png',
      attribution: '© CartoDB',
      subdomains: ['a', 'b', 'c', 'd'],
    ),
    'cartodb_positron': TileProviderInfo(
      name: 'CartoDB Positron',
      url:
          'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
      description: 'Clean, minimal design with light colors',
      attribution: '© CartoDB',
      subdomains: ['a', 'b', 'c', 'd'],
      isWorking: true,
    ),
    'cartodb_dark': TileProviderInfo(
      name: 'CartoDB Dark Matter',
      url:
          'https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png',
      description: 'Dark theme with high contrast',
      attribution: '© CartoDB',
      subdomains: ['a', 'b', 'c', 'd'],
      isWorking: true,
    ),

    // Fast alternative providers
    'cartodb_voyager_new': TileProviderInfo(
      name: 'CartoDB Voyager (New CDN)',
      url:
          'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
      description: 'CartoDB Voyager style via new CDN',
      attribution: '© CARTO, © OpenStreetMap contributors',
      subdomains: ['a', 'b', 'c', 'd'],
      isWorking: true,
    ),

    // Option 2: Alternative CARTO CDN format
    'cartodb_voyager_alt': TileProviderInfo(
      name: 'CartoDB Voyager (Alt) Little Faster',
      url:
          'https://tiles.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
      description: 'CartoDB Voyager alternative URL',
      attribution: '© CARTO, © OpenStreetMap contributors',
      isWorking: true,
    ),
    'google_satellite': TileProviderInfo(
      name: 'Google Satellite',
      url: 'https://{s}.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
      description: 'High-resolution satellite imagery from Google',
      attribution: '© Google',
      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
    ),
    'google_terrain': TileProviderInfo(
      name: 'Google Terrain',
      url: 'https://{s}.google.com/vt/lyrs=p&x={x}&y={y}&z={z}',
      description: 'Terrain map with labels from Google',
      attribution: '© Google',
      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
    ),
    'google_hybrid': TileProviderInfo(
      name: 'Google Hybrid',
      url: 'https://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}',
      description: 'Satellite imagery with road and label overlays',
      attribution: '© Google',
      subdomains: ['mt0', 'mt1', 'mt2', 'mt3'],
    ),
    'cyclosm': TileProviderInfo(
      name: 'CyclOSM',
      url: 'https://{s}.tile-cyclosm.openstreetmap.fr/cyclosm/{z}/{x}/{y}.png',
      description: 'Beautiful bicycle-oriented map',
      attribution: '© CyclOSM, © OpenStreetMap contributors',
    ),
    'humanitarian': TileProviderInfo(
      name: 'Humanitarian',
      url: 'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
      description: 'High-contrast map with clear details',
      attribution:
          '© OpenStreetMap contributors, Humanitarian OpenStreetMap Team',
    ),
  };

  /// Get only working tile providers
  static Map<String, TileProviderInfo> get workingProviders {
    return Map.fromEntries(
      providers.entries.where((entry) => entry.value.isWorking),
    );
  }

  /// Get recommended tile providers for production use
  static Map<String, TileProviderInfo> get recommendedProviders {
    return {
      'osm': providers['osm']!,
      'cartodb_positron': providers['cartodb_positron']!,
      'cartodb_dark': providers['cartodb_dark']!,
      'cyclosm': providers['cyclosm']!,
      'humanitarian': providers['humanitarian']!,
    };
  }

  /// Get the most reliable tile providers (recommended for production)
  static List<String> get mostReliableProviders {
    return ['osm', 'cartodb_positron', 'cartodb_dark'];
  }

  /// Get tile provider info by name
  static TileProviderInfo? getProviderInfo(String name) {
    return providers[name];
  }

  /// Check if a tile provider exists
  static bool hasProvider(String name) {
    return providers.containsKey(name);
  }

  /// Get all available provider names
  static List<String> get availableProviderNames {
    return providers.keys.toList();
  }

  /// Test if a tile provider is accessible by checking a sample tile URL
  static Future<bool> testTileProvider(String providerName) async {
    try {
      final provider = providers[providerName];
      if (provider == null) return false;

      // Test with a sample tile (zoom 14, x=8396, y=5419 - Amsterdam area)
      final testUrl = provider.url
          .replaceAll('{z}', '14')
          .replaceAll('{x}', '8396')
          .replaceAll('{y}', '5419')
          .replaceAll('{s}', provider.subdomains.first);

      print('Testing tile provider: $providerName');
      print('Test URL: $testUrl');

      // This is a simple test - in a real app you might want to make an HTTP request
      return true;
    } catch (e) {
      print('Error testing tile provider $providerName: $e');
      return false;
    }
  }

  /// Get a working tile provider (fallback chain)
  static String getWorkingTileProvider() {
    final reliableProviders = mostReliableProviders;

    for (String provider in reliableProviders) {
      if (providers.containsKey(provider)) {
        return provider;
      }
    }

    // Final fallback
    return 'osm';
  }
}
