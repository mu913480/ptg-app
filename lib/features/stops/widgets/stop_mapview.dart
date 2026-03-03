import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
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
  PolylineAnnotationManager? _polylineManager;

  void _onMapCreated(MapboxMap mapboxMap) async {
    _mapboxMap = mapboxMap;

    // Create annotation managers
    _annotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();
    _polylineManager = await mapboxMap.annotations
        .createPolylineAnnotationManager();

    if (!mounted) return;
    final stops = context.read<StopBloc>().state.stops;
    if (stops.isNotEmpty) {
      await _addMarkers(stops);
      await _addPolyline(stops);
      await _fitBoundsToStops(stops);
    }
  }

  /// Creates a beautiful white-background label image with the stop name.
  Future<Uint8List> _createLabelImage(String label) async {
    const double fontSize = 28.0;
    const double paddingH = 20.0;
    const double paddingV = 10.0;
    const double borderRadius = 14.0;

    // Measure the text
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: label,
        style: const TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A2E),
          letterSpacing: 0.3,
        ),
      ),
    )..layout();

    final double width = textPainter.width + paddingH * 2;
    final double height = textPainter.height + paddingV * 2;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw shadow
    final shadowPaint = Paint()
      ..color = const Color(0x40000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(2, 4, width, height),
        const Radius.circular(borderRadius),
      ),
      shadowPaint,
    );

    // Draw white background
    final bgPaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        const Radius.circular(borderRadius),
      ),
      bgPaint,
    );

    // Draw subtle border
    final borderPaint = Paint()
      ..color = const Color(0x1A000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        const Radius.circular(borderRadius),
      ),
      borderPaint,
    );

    // Draw text
    textPainter.paint(canvas, const Offset(paddingH, paddingV));

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (width + 4).toInt(), // extra space for shadow
      (height + 8).toInt(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  /// Creates a Google Maps-style red teardrop pin marker.
  Future<Uint8List> _createMarkerImage() async {
    const double width = 64.0;
    const double height = 76.0;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final centerX = width / 2;
    const circleRadius = 24.0;
    const circleY = 30.0;

    // Draw shadow
    final shadowPaint = Paint()
      ..color = const Color(0x40000000)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    final shadowPath = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(centerX + 1, circleY + 1),
          radius: circleRadius,
        ),
      )
      ..moveTo(centerX - 14 + 1, circleY + 18 + 1)
      ..lineTo(centerX + 1, height - 6 + 1)
      ..lineTo(centerX + 14 + 1, circleY + 18 + 1)
      ..close();
    canvas.drawPath(shadowPath, shadowPaint);

    // Draw the red teardrop body
    final pinPaint = Paint()..color = const Color(0xFFEA4335);
    final pinPath = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(centerX, circleY), radius: circleRadius),
      )
      ..moveTo(centerX - 14, circleY + 18)
      ..lineTo(centerX, height - 6)
      ..lineTo(centerX + 14, circleY + 18)
      ..close();
    canvas.drawPath(pinPath, pinPaint);

    // Draw the white inner circle
    final innerCirclePaint = Paint()..color = const Color(0xFFFFFFFF);
    canvas.drawCircle(Offset(centerX, circleY), 10.0, innerCirclePaint);

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  Future<void> _addMarkers(List<Stop> stops) async {
    if (_annotationManager == null) return;

    final markerImage = await _createMarkerImage();

    // Create label images for each stop
    final labelImages = <Uint8List>[];
    for (final stop in stops) {
      labelImages.add(await _createLabelImage(stop.name));
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

  /// Draws a polyline connecting all stops in order.
  Future<void> _addPolyline(List<Stop> stops) async {
    if (_polylineManager == null || stops.length < 2) return;

    final coordinates = stops
        .map((stop) => Position(stop.longitude, stop.latitude))
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
