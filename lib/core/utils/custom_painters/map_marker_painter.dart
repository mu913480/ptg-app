import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Utility class for creating custom map marker and label images.
class MapMarkerPainter {
  const MapMarkerPainter._();

  /// Creates a white-background label image with the given [label] text.
  static Future<Uint8List> createLabelImage(String label) async {
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

  /// Creates a Google Maps-style red teardrop pin marker image.
  static Future<Uint8List> createMarkerImage() async {
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
}
