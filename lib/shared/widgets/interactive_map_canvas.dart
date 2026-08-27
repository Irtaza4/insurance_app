import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/models/insurance_models.dart';

class InteractiveMapCanvas extends StatefulWidget {
  final List<Hospital> hospitals;
  final Hospital? selectedHospital;
  final ValueChanged<Hospital> onSelectHospital;

  const InteractiveMapCanvas({
    super.key,
    required this.hospitals,
    required this.selectedHospital,
    required this.onSelectHospital,
  });

  @override
  State<InteractiveMapCanvas> createState() => _InteractiveMapCanvasState();
}

class _InteractiveMapCanvasState extends State<InteractiveMapCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onTapUp: (details) {
                final size = Size(constraints.maxWidth, constraints.maxHeight);
                for (final hospital in widget.hospitals) {
                  final pinOffset = Offset(
                    hospital.lngOffsetRatio * size.width,
                    hospital.latOffsetRatio * size.height,
                  );
                  if ((details.localPosition - pinOffset).distance < 45) {
                    widget.onSelectHospital(hospital);
                    break;
                  }
                }
              },
              child: CustomPaint(
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: _StylizedMapPainter(
                  hospitals: widget.hospitals,
                  selectedHospital: widget.selectedHospital,
                  pulseValue: _pulseController.value,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _StylizedMapPainter extends CustomPainter {
  final List<Hospital> hospitals;
  final Hospital? selectedHospital;
  final double pulseValue;

  _StylizedMapPainter({
    required this.hospitals,
    required this.selectedHospital,
    required this.pulseValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Warm Off-White / Beige Base Canvas
    final bgPaint = Paint()..color = const Color(0xFFEEEBE6);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // 2. Prospect Park & Green Area on Left
    final parkPaint = Paint()..color = const Color(0xFFE4E9E0);
    final parkPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.42, 0)
      ..quadraticBezierTo(size.width * 0.38, size.height * 0.35, size.width * 0.30, size.height * 0.58)
      ..quadraticBezierTo(size.width * 0.22, size.height * 0.8, 0, size.height * 0.88)
      ..close();
    canvas.drawPath(parkPath, parkPaint);

    // 3. Water body (Lake & Boathouse bay)
    final waterPaint = Paint()..color = const Color(0xFFD6E2E6);
    final waterPath = Path()
      ..moveTo(size.width * 0.08, size.height * 0.45)
      ..quadraticBezierTo(size.width * 0.20, size.height * 0.42, size.width * 0.24, size.height * 0.54)
      ..quadraticBezierTo(size.width * 0.16, size.height * 0.62, size.width * 0.05, size.height * 0.58)
      ..close();
    canvas.drawPath(waterPath, waterPaint);

    // 4. Roads / Street Grid
    final majorRoadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.round;

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFE3DFD8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    // Horizontal & Diagonal Avenues matching Image 2
    final horizontalRoads = [
      // Empire Blvd
      Path()
        ..moveTo(0, size.height * 0.72)
        ..lineTo(size.width, size.height * 0.74),
      // Sterling St
      Path()
        ..moveTo(0, size.height * 0.76)
        ..lineTo(size.width, size.height * 0.78),
      // Lefferts Ave
      Path()
        ..moveTo(0, size.height * 0.80)
        ..lineTo(size.width, size.height * 0.82),
      // Maple St
      Path()
        ..moveTo(size.width * 0.3, size.height * 0.85)
        ..lineTo(size.width, size.height * 0.86),
      // Midwood St
      Path()
        ..moveTo(size.width * 0.3, size.height * 0.88)
        ..lineTo(size.width, size.height * 0.89),
      // Fenimore St
      Path()
        ..moveTo(0, size.height * 0.92)
        ..lineTo(size.width, size.height * 0.93),
      // Hawthorne St
      Path()
        ..moveTo(0, size.height * 0.96)
        ..lineTo(size.width, size.height * 0.97),
    ];

    // Vertical Avenues
    final verticalRoads = [
      // Bedford Ave
      Path()
        ..moveTo(size.width * 0.80, 0)
        ..lineTo(size.width * 0.82, size.height),
      // Flatbush Ave
      Path()
        ..moveTo(size.width * 0.58, 0)
        ..lineTo(size.width * 0.60, size.height),
      // Ocean Ave
      Path()
        ..moveTo(size.width * 0.34, 0)
        ..lineTo(size.width * 0.36, size.height),
    ];

    for (final road in horizontalRoads) {
      canvas.drawPath(road, majorRoadPaint);
    }
    for (final road in verticalRoads) {
      canvas.drawPath(road, majorRoadPaint);
    }
    for (final road in horizontalRoads) {
      canvas.drawPath(road, minorRoadPaint);
    }
    for (final road in verticalRoads) {
      canvas.drawPath(road, minorRoadPaint);
    }

    // 5. Street & Landmark Labels
    _drawText(canvas, 'Prospect Park', Offset(size.width * 0.05, size.height * 0.74), fontSize: 10, isBold: true);
    _drawText(canvas, 'Prospect Park Boathouse', Offset(size.width * 0.04, size.height * 0.68), fontSize: 8.5);
    _drawText(canvas, 'LeFrak Center at Lakeside', Offset(size.width * 0.08, size.height * 0.93), fontSize: 8.5);
    _drawText(canvas, 'Smorgasburg Prospect Pk', Offset(size.width * 0.22, size.height * 0.86), fontSize: 8.5);
    _drawText(canvas, 'Empire Blvd', Offset(size.width * 0.50, size.height * 0.73), fontSize: 8.5);
    _drawText(canvas, 'Sterling St', Offset(size.width * 0.58, size.height * 0.76), fontSize: 8.5);
    _drawText(canvas, 'Lefferts Ave', Offset(size.width * 0.55, size.height * 0.79), fontSize: 8.5);
    _drawText(canvas, 'Prospect Pk', Offset(size.width * 0.51, size.height * 0.82), fontSize: 9, isBold: true);
    _drawText(canvas, 'Maple St', Offset(size.width * 0.60, size.height * 0.84), fontSize: 8.5);
    _drawText(canvas, 'Midwood St', Offset(size.width * 0.60, size.height * 0.87), fontSize: 8.5);
    _drawText(canvas, 'Fenimore St', Offset(size.width * 0.62, size.height * 0.92), fontSize: 8.5);
    _drawText(canvas, 'Hawthorne St', Offset(size.width * 0.63, size.height * 0.95), fontSize: 8.5);
    _drawText(canvas, 'Risbo 🍴', Offset(size.width * 0.50, size.height * 0.98), fontSize: 8.5);
    _drawText(canvas, 'Bedford Ave', Offset(size.width * 0.79, size.height * 0.74), fontSize: 8.5, isVertical: true);

    // 6. Hospital Pins with Multi-Ring Radar on Selected Location
    final selectedPin = Offset(size.width * 0.48, size.height * 0.89);

    // Glowing Concentric Radar Target (Matching Image 2)
    final pulseScale = 1.0 + pulseValue * 0.25;

    // Outer soft peach halo
    final outerHalo = Paint()
      ..color = const Color(0xFFFFB28A).withValues(alpha: 0.35 * (1.0 - pulseValue * 0.4))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(selectedPin, 44 * pulseScale, outerHalo);

    // Mid peach ring
    final midRing = Paint()
      ..color = const Color(0xFFFF8E56).withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(selectedPin, 28 * pulseScale, midRing);

    // Center filled orange circle
    final centerFill = Paint()
      ..shader = const RadialGradient(
        colors: [
          Color(0xFFFF9554),
          Color(0xFFE85420),
        ],
      ).createShader(Rect.fromCircle(center: selectedPin, radius: 14));
    canvas.drawCircle(selectedPin, 13, centerFill);

    // Center white dot
    final centerDot = Paint()..color = Colors.white;
    canvas.drawCircle(selectedPin, 4.5, centerDot);

    // 7. Other Location Pins (Bedford Ave, Prospect Pk, LeFrak)
    _drawSecondaryMarker(canvas, Offset(size.width * 0.80, size.height * 0.84));
    _drawSecondaryMarker(canvas, Offset(size.width * 0.14, size.height * 0.87));
    _drawSecondaryMarker(canvas, Offset(size.width * 0.36, size.height * 0.93));
    _drawSecondaryMarker(canvas, Offset(size.width * 0.84, size.height * 0.98));
  }

  void _drawSecondaryMarker(Canvas canvas, Offset center) {
    // Outer semi-transparent grey circle
    final outerRing = Paint()
      ..color = const Color(0xFF1E1816).withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 18, outerRing);

    // Dark grey center ring
    final innerCircle = Paint()..color = const Color(0xFF383330);
    canvas.drawCircle(center, 7.5, innerCircle);

    // White center dot
    final whiteDot = Paint()..color = Colors.white;
    canvas.drawCircle(center, 2.5, whiteDot);
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset, {
    double fontSize = 9,
    bool isBold = false,
    bool isVertical = false,
  }) {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        color: const Color(0xFF9E9993),
        fontSize: fontSize,
        fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
        letterSpacing: 0.1,
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    if (isVertical) {
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(math.pi / 2);
      textPainter.paint(canvas, Offset.zero);
      canvas.restore();
    } else {
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant _StylizedMapPainter oldDelegate) {
    return oldDelegate.pulseValue != pulseValue ||
        oldDelegate.selectedHospital?.id != selectedHospital?.id;
  }
}
