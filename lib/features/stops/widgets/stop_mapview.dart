import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:ptg/features/stops/bloc/stop_bloc.dart';
import 'package:ptg/features/stops/models/stop_model.dart';

class StopMapView extends StatefulWidget {
  const StopMapView({super.key});

  @override
  State<StopMapView> createState() => _StopMapViewState();
}

class _StopMapViewState extends State<StopMapView> {
  MapboxMap? _mapboxMap;
  PointAnnotationManager? _annotationManager;

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    // Create the annotation manager for markers
    _annotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();

    // Store bloc reference before async gap
    if (!mounted) return;
    final stops = context.read<StopBloc>().state.stops;
    if (stops.isNotEmpty) {
      await _addMarkers(stops);
      await _fitBoundsToStops(stops);
    }
  }

  Future<Uint8List> _createMarkerImage() async {
    const size = 40.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black26
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(
      const Offset(size / 2, size / 2 + 2),
      size / 2.5,
      shadowPaint,
    );

    // Outer circle
    final outerPaint = Paint()..color = const Color(0xFFE53935);
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2.5, outerPaint);

    // Inner circle
    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 5, innerPaint);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _addMarkers(List<Stop> stops) async {
    if (_annotationManager == null) return;

    final markerImage = await _createMarkerImage();

    final annotations = stops.map((stop) {
      return PointAnnotationOptions(
        geometry: Point(coordinates: Position(stop.longitude, stop.latitude)),
        image: markerImage,
        iconSize: 1.0,
        textField: stop.name,
        textOffset: [0, 1.5],
        textSize: 12.0,
        textColor: Colors.black.toARGB32(),
        textHaloColor: Colors.white.toARGB32(),
        textHaloWidth: 1.5,
      );
    }).toList();

    await _annotationManager!.createMulti(annotations);
  }

  Future<void> _fitBoundsToStops(List<Stop> stops) async {
    if (_mapboxMap == null || stops.isEmpty) return;

    if (stops.length == 1) {
      // Single stop — just fly to it
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

    // Calculate bounds
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

        // Default center on Pakistan
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
