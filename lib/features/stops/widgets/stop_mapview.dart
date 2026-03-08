import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:ptg/features/stops/bloc/stop_bloc.dart';
import 'package:ptg/features/stops/models/stop_model.dart';
import 'package:ptg/core/utils/custom_painters/map_marker_painter.dart';

class StopMapView extends StatefulWidget {
  const StopMapView({super.key});

  @override
  State<StopMapView> createState() => _StopMapViewState();
}

class _StopMapViewState extends State<StopMapView> {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _annotationManager;
  PolylineAnnotationManager? _polylineManager;

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    // Create annotation managers
    _annotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();
    _polylineManager = await mapboxMap.annotations
        .createPolylineAnnotationManager();

    if (!mounted) return;
    final state = context.read<StopBloc>().state;
    final stops = state.stops;
    if (stops.isNotEmpty) {
      await _addMarkers(stops);
      await _fitBoundsToStops(stops);

      // If route is already loaded, draw it directly, else fetch it
      if (state.routeCoordinates.isNotEmpty) {
        await _drawRoutePolyline(state.routeCoordinates);
      } else {
        context.read<StopBloc>().add(LoadRoutePolyline(stops));
      }
    }
  }

  Future<void> _addMarkers(List<Stop> stops) async {
    if (_annotationManager == null) return;

    final markerImage = await MapMarkerPainter.createMarkerImage();

    // Create label images for each stop
    final labelImages = <Uint8List>[];
    for (final stop in stops) {
      labelImages.add(await MapMarkerPainter.createLabelImage(stop.name));
    }

    // Add Google Maps-style marker pins
    final pinAnnotations = stops.map((stop) {
      return PointAnnotationOptions(
        geometry: Point(coordinates: Position(stop.longitude, stop.latitude)),
        image: markerImage,
        iconSize: 0.7,
        iconAnchor: IconAnchor.BOTTOM,
      );
    }).toList();
    await _annotationManager!.createMulti(pinAnnotations);

    // Add white-background label annotations above pins
    final labelAnnotations = <PointAnnotationOptions>[];
    for (int i = 0; i < stops.length; i++) {
      labelAnnotations.add(
        PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(stops[i].longitude, stops[i].latitude),
          ),
          image: labelImages[i],
          iconSize: 0.65,
          iconAnchor: IconAnchor.BOTTOM,
          iconOffset: [0, -50],
        ),
      );
    }
    await _annotationManager!.createMulti(labelAnnotations);
  }

  /// Draws a polyline using exact road coordinates.
  Future<void> _drawRoutePolyline(List<List<double>> routeCoords) async {
    if (_polylineManager == null || routeCoords.length < 2) return;

    // Clear existing polylines
    await _polylineManager!.deleteAll();

    final coordinates = routeCoords
        .map((coord) => Position(coord[0], coord[1]))
        .toList();

    await _polylineManager!.create(
      PolylineAnnotationOptions(
        geometry: LineString(coordinates: coordinates),
        lineColor: const Color(0xFF4A90D9).value,
        lineWidth: 3.5,
        lineOpacity: 0.85,
      ),
    );
  }

  Future<void> _fitBoundsToStops(List<Stop> stops) async {
    if (_mapboxMap == null || stops.isEmpty) return;

    if (stops.length == 1) {
      await _mapboxMap!.flyTo(
        CameraOptions(
          center: Point(
            coordinates: Position(stops.first.longitude, stops.first.latitude),
          ),
          zoom: 14.0,
        ),
        MapAnimationOptions(duration: 1000),
      );
      return;
    }

    double minLat = stops.first.latitude;
    double maxLat = stops.first.latitude;
    double minLng = stops.first.longitude;
    double maxLng = stops.first.longitude;

    for (final stop in stops) {
      if (stop.latitude < minLat) minLat = stop.latitude;
      if (stop.latitude > maxLat) maxLat = stop.latitude;
      if (stop.longitude < minLng) minLng = stop.longitude;
      if (stop.longitude > maxLng) maxLng = stop.longitude;
    }

    final bounds = CoordinateBounds(
      southwest: Point(coordinates: Position(minLng, minLat)),
      northeast: Point(coordinates: Position(maxLng, maxLat)),
      infiniteBounds: false,
    );

    final camera = await _mapboxMap!.cameraForCoordinateBounds(
      bounds,
      MbxEdgeInsets(top: 80, left: 80, bottom: 80, right: 80),
      null,
      null,
      null,
      null,
    );

    await _mapboxMap!.flyTo(camera, MapAnimationOptions(duration: 1000));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StopBloc, StopState>(
      listenWhen: (previous, current) =>
          previous.routeCoordinates != current.routeCoordinates,
      listener: (context, state) {
        if (state.routeCoordinates.isNotEmpty) {
          _drawRoutePolyline(state.routeCoordinates);
        }
      },
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

        final initialLat = state.stops.first.latitude;
        final initialLng = state.stops.first.longitude;

        return MapWidget(
          cameraOptions: CameraOptions(
            center: Point(coordinates: Position(initialLng, initialLat)),
            zoom: 5.0,
          ),
          onMapCreated: _onMapCreated,
        );
      },
    );
  }
}
