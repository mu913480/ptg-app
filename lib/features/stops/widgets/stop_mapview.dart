import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ptg/features/stops/bloc/stop_bloc.dart';
import 'package:ptg/features/stops/widgets/tile_providers.dart';

class StopMapView extends StatelessWidget {
  const StopMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StopBloc, StopState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.error.isNotEmpty) {
          return Center(child: Text('Error: ${state.error}'));
        }

        if (state.stops.isEmpty) {
          return const Center(child: Text('No stops found.'));
        }

        final markers = state.stops.map((stop) {
          return Marker(
            point: LatLng(stop.latitude, stop.longitude),
            width: 80,
            height: 80,
            child: Column(
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 40),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Text(
                    stop.name,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList();

        // Calculate initial center (average of all stops)
        double avgLat = 0;
        double avgLng = 0;
        for (var stop in state.stops) {
          avgLat += stop.latitude;
          avgLng += stop.longitude;
        }
        avgLat /= state.stops.length;
        avgLng /= state.stops.length;

        return FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(avgLat, avgLng),
            initialZoom: 13,
          ),
          children: [
            // AvailableTileProviders.providers['cartodb_voyager']!
            //     .toFlutterMapTileLayer(),
            TileLayer(
              urlTemplate:
                  // 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                  'https://{s}.google.com/vt/lyrs=s,h&x={x}&y={y}&z={z}',
              userAgentPackageName: 'com.example.app',
              // It's good practice to add a subdomains list if the provider uses them
            ),
            MarkerLayer(markers: markers),
          ],
        );
      },
    );
  }
}
