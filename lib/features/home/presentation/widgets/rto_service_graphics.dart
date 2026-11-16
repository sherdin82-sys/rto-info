import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Rich, layered, high-performance Flutter canvas graphic components for the
/// CarInfo-style Essential RTO Services 4x2 grid.
///
/// Designed to provide authentic, colorful, layered pictorial illustrations:
/// 1. [PosChallanGraphic] - Handheld electronic POS terminal with printed challan receipt
/// 2. [CarInsuranceGraphic] - Sleek car front with glowing security shield & checkmark
/// 3. [BikeInsuranceGraphic] - Motorcycle profile with glowing security shield & checkmark
/// 4. [VehicleReportGraphic] - Inspection clipboard with checklist & sharpened pencil
/// 5. [RcSearchGraphic] - Monospace IND number plate with metallic magnifying glass
/// 6. [FastagGraphic] - NETC FASTag RFID windshield toll sticker with saffron & green stripes
/// 7. [CarCheckGraphic] - Front-fascia vehicle with propped-open hood & engine diagnostics wrench
/// 8. [CarLoanGraphic] - Stack of golden ₹ Rupee coins with RBI green currency note & car key

// -----------------------------------------------------------------------------
// 1. POS CHALLAN GRAPHIC
// -----------------------------------------------------------------------------
class PosChallanGraphic extends StatelessWidget {
  final double width;
  final double height;
  final bool isDark;

  const PosChallanGraphic({
    super.key,
    this.width = 48,
    this.height = 44,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _PosChallanPainter(isDark: isDark)),
    );
  }
}

class _PosChallanPainter extends CustomPainter {
  final bool isDark;
  _PosChallanPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // 1. Printed receipt paper emerging from top
    final paperPath = Path();
    final double pLeft = w * 0.28;
    final double pRight = w * 0.72;
    final double pTop = h * 0.04;
    final double pBottom = h * 0.32;

    paperPath.moveTo(pLeft, pBottom);
    paperPath.lineTo(pLeft, pTop + 2);
    // Serrated top edge
    paperPath.lineTo(pLeft + (pRight - pLeft) * 0.2, pTop);
    paperPath.lineTo(pLeft + (pRight - pLeft) * 0.4, pTop + 2.5);
    paperPath.lineTo(pLeft + (pRight - pLeft) * 0.6, pTop);
    paperPath.lineTo(pLeft + (pRight - pLeft) * 0.8, pTop + 2.5);
    paperPath.lineTo(pRight, pTop);
    paperPath.lineTo(pRight, pBottom);
    paperPath.close();

    // Paper shadow
    canvas.drawShadow(paperPath, Colors.black.withOpacity(0.18), 3, false);

    // Paper background
    final paperPaint = Paint()..color = const Color(0xFFF8FAFC);
    canvas.drawPath(paperPath, paperPaint);

    // Paper border
    final paperBorder = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawPath(paperPath, paperBorder);

    // Printed receipt text lines
    final linePaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(pLeft + 3, h * 0.12),
      Offset(pRight - 3, h * 0.12),
      linePaint,
    );
    canvas.drawLine(
      Offset(pLeft + 3, h * 0.18),
      Offset(pRight - 6, h * 0.18),
      linePaint,
    );
    // CHALLAN red stamp dot
    final redDotPaint = Paint()..color = const Color(0xFFEF4444);
    canvas.drawCircle(Offset(pRight - 4, h * 0.24), 1.5, redDotPaint);
    canvas.drawLine(
      Offset(pLeft + 3, h * 0.24),
      Offset(pRight - 7, h * 0.24),
      linePaint,
    );

    // 2. POS Terminal Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.16, h * 0.26, w * 0.84, h * 0.96),
      const Radius.circular(7),
    );

    // POS Shadow
    canvas.drawRRect(
      bodyRect,
      Paint()
        ..color = Colors.black.withOpacity(0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Body Gradient
    final bodyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? const [Color(0xFF334155), Color(0xFF1E293B)]
          : const [Color(0xFF1E293B), Color(0xFF0F172A)],
    );
    final bodyPaint = Paint()
      ..shader = bodyGradient.createShader(bodyRect.outerRect);
    canvas.drawRRect(bodyRect, bodyPaint);

    // Body stroke
    final bodyStroke = Paint()
      ..color = const Color(0xFF475569)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;
    canvas.drawRRect(bodyRect, bodyStroke);

    // Printer slot
    final slotRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.24, h * 0.28, w * 0.76, h * 0.33),
      const Radius.circular(2),
    );
    canvas.drawRRect(slotRect, Paint()..color = const Color(0xFF020617));

    // 3. LCD Screen
    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.24, h * 0.37, w * 0.76, h * 0.56),
      const Radius.circular(3.5),
    );
    final screenPaint = Paint()..color = const Color(0xFF022C22);
    canvas.drawRRect(screenRect, screenPaint);

    // Glowing green ₹ and amount line on screen
    final greenTextPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;

    // Mini ₹ glyph on screen
    canvas.drawLine(
      Offset(w * 0.30, h * 0.43),
      Offset(w * 0.38, h * 0.43),
      greenTextPaint,
    );
    canvas.drawLine(
      Offset(w * 0.30, h * 0.47),
      Offset(w * 0.38, h * 0.47),
      greenTextPaint,
    );
    canvas.drawLine(
      Offset(w * 0.30, h * 0.43),
      Offset(w * 0.30, h * 0.50),
      greenTextPaint,
    );
    canvas.drawLine(
      Offset(w * 0.42, h * 0.46),
      Offset(w * 0.70, h * 0.46),
      greenTextPaint,
    );

    // 4. Tactile Keypad (3 rows of 3 buttons)
    final keyPaint = Paint()..color = const Color(0xFF475569);
    final keyGreen = Paint()..color = const Color(0xFF10B981);
    final keyRed = Paint()..color = const Color(0xFFEF4444);

    final double col1 = w * 0.27;
    final double col2 = w * 0.45;
    final double col3 = w * 0.63;
    final double kw = w * 0.12;
    final double kh = h * 0.065;

    // Row 1
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(col1, h * 0.62, kw, kh),
        const Radius.circular(1.5),
      ),
      keyPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(col2, h * 0.62, kw, kh),
        const Radius.circular(1.5),
      ),
      keyPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(col3, h * 0.62, kw, kh),
        const Radius.circular(1.5),
      ),
      keyPaint,
    );

    // Row 2
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(col1, h * 0.72, kw, kh),
        const Radius.circular(1.5),
      ),
      keyPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(col2, h * 0.72, kw, kh),
        const Radius.circular(1.5),
      ),
      keyPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(col3, h * 0.72, kw, kh),
        const Radius.circular(1.5),
      ),
      keyPaint,
    );

    // Row 3 (Cancel Red, Key, Enter Green)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(col1, h * 0.82, kw, kh),
        const Radius.circular(1.5),
      ),
      keyRed,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(col2, h * 0.82, kw, kh),
        const Radius.circular(1.5),
      ),
      keyPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(col3, h * 0.82, kw, kh),
        const Radius.circular(1.5),
      ),
      keyGreen,
    );

    // 5. Crimson Card Edge on Right
    final cardPath = Path();
    cardPath.moveTo(w * 0.80, h * 0.35);
    cardPath.lineTo(w * 0.94, h * 0.28);
    cardPath.lineTo(w * 0.96, h * 0.50);
    cardPath.lineTo(w * 0.82, h * 0.56);
    cardPath.close();

    final cardPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
      ).createShader(cardPath.getBounds());
    canvas.drawPath(cardPath, cardPaint);

    // Card gold chip accent
    final chipPaint = Paint()..color = const Color(0xFFFBBF24);
    canvas.drawCircle(Offset(w * 0.88, h * 0.40), 1.6, chipPaint);
  }

  @override
  bool shouldRepaint(covariant _PosChallanPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

// -----------------------------------------------------------------------------
// 2. CAR INSURANCE GRAPHIC
// -----------------------------------------------------------------------------
class CarInsuranceGraphic extends StatelessWidget {
  final double width;
  final double height;

  const CarInsuranceGraphic({super.key, this.width = 48, this.height = 44});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _CarInsurancePainter()),
    );
  }
}

class _CarInsurancePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // 1. Glowing Teal Security Shield in background (offset right/center)
    final shieldPath = Path();
    final double sLeft = w * 0.38;
    final double sRight = w * 0.92;
    final double sTop = h * 0.05;
    final double sMid = sLeft + (sRight - sLeft) / 2;
    final double sBottom = h * 0.70;

    shieldPath.moveTo(sLeft, sTop + 4);
    shieldPath.quadraticBezierTo(sMid, sTop - 2, sRight, sTop + 4);
    shieldPath.lineTo(sRight, sTop + (sBottom - sTop) * 0.55);
    shieldPath.quadraticBezierTo(sRight - 2, sBottom - 4, sMid, sBottom);
    shieldPath.quadraticBezierTo(
      sLeft + 2,
      sBottom - 4,
      sLeft,
      sTop + (sBottom - sTop) * 0.55,
    );
    shieldPath.close();

    // Shield outer glow
    canvas.drawPath(
      shieldPath,
      Paint()
        ..color = const Color(0xFF06B6D4).withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Shield gradient fill
    final shieldGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF22D3EE), Color(0xFF0D9488)],
    ).createShader(shieldPath.getBounds());
    canvas.drawPath(shieldPath, Paint()..shader = shieldGradient);

    // Shield border
    canvas.drawPath(
      shieldPath,
      Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // Shield White Checkmark
    final checkPath = Path();
    checkPath.moveTo(sMid - 6, sTop + (sBottom - sTop) * 0.40);
    checkPath.lineTo(sMid - 1, sTop + (sBottom - sTop) * 0.48);
    checkPath.lineTo(sMid + 7, sTop + (sBottom - sTop) * 0.30);

    canvas.drawPath(
      checkPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // 2. Modern White/Silver Car Front in foreground
    final carLeft = w * 0.06;
    final carRight = w * 0.74;
    final carTop = h * 0.42;
    final carBottom = h * 0.94;
    final carMid = carLeft + (carRight - carLeft) / 2;

    // Car Shadow
    canvas.drawOval(
      Rect.fromLTRB(carLeft - 2, carBottom - 3, carRight + 2, carBottom + 4),
      Paint()
        ..color = Colors.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Car wheels
    final wheelPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(carLeft, carBottom - 7, carLeft + 6, carBottom + 2),
        const Radius.circular(2),
      ),
      wheelPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(carRight - 6, carBottom - 7, carRight, carBottom + 2),
        const Radius.circular(2),
      ),
      wheelPaint,
    );

    // Car Cabin / Windshield
    final cabinPath = Path();
    cabinPath.moveTo(carLeft + 8, carTop + 10);
    cabinPath.lineTo(carLeft + 12, carTop);
    cabinPath.lineTo(carRight - 12, carTop);
    cabinPath.lineTo(carRight - 8, carTop + 10);
    cabinPath.close();

    // Windshield glass
    final glassGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    ).createShader(cabinPath.getBounds());
    canvas.drawPath(cabinPath, Paint()..shader = glassGradient);

    // Windshield glare line
    final glarePaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(carLeft + 16, carTop + 2),
      Offset(carLeft + 12, carTop + 8),
      glarePaint,
    );

    // Car Body Fascia
    final bodyPath = Path();
    bodyPath.moveTo(carLeft + 5, carTop + 10);
    bodyPath.quadraticBezierTo(carMid, carTop + 8, carRight - 5, carTop + 10);
    bodyPath.quadraticBezierTo(carRight, carTop + 12, carRight, carTop + 18);
    bodyPath.lineTo(carRight, carBottom - 4);
    bodyPath.quadraticBezierTo(carMid, carBottom - 1, carLeft, carBottom - 4);
    bodyPath.lineTo(carLeft, carTop + 18);
    bodyPath.quadraticBezierTo(carLeft, carTop + 12, carLeft + 5, carTop + 10);
    bodyPath.close();

    final carPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFFFFFF), Color(0xFFE2E8F0)],
      ).createShader(bodyPath.getBounds());
    canvas.drawPath(carPath, carPaint);

    final carBorder = Paint()
      ..color = const Color(0xFF94A3B8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawPath(bodyPath, carBorder);

    // Headlights (glowing cyan / white)
    final lightPaint = Paint()..color = const Color(0xFF38BDF8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(carLeft + 3, carTop + 12, carLeft + 10, carTop + 16),
        const Radius.circular(2),
      ),
      lightPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(carRight - 10, carTop + 12, carRight - 3, carTop + 16),
        const Radius.circular(2),
      ),
      lightPaint,
    );

    // Center Grille
    final grilleRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(carMid - 8, carTop + 14, carMid + 8, carTop + 20),
      const Radius.circular(2),
    );
    canvas.drawRRect(grilleRect, Paint()..color = const Color(0xFF1E293B));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// 3. BIKE INSURANCE GRAPHIC
// -----------------------------------------------------------------------------
class BikeInsuranceGraphic extends StatelessWidget {
  final double width;
  final double height;

  const BikeInsuranceGraphic({super.key, this.width = 48, this.height = 44});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _BikeInsurancePainter()),
    );
  }
}

class _BikeInsurancePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // 1. Glowing Teal Security Shield in background (offset right/top)
    final shieldPath = Path();
    final double sLeft = w * 0.40;
    final double sRight = w * 0.94;
    final double sTop = h * 0.05;
    final double sMid = sLeft + (sRight - sLeft) / 2;
    final double sBottom = h * 0.70;

    shieldPath.moveTo(sLeft, sTop + 4);
    shieldPath.quadraticBezierTo(sMid, sTop - 2, sRight, sTop + 4);
    shieldPath.lineTo(sRight, sTop + (sBottom - sTop) * 0.55);
    shieldPath.quadraticBezierTo(sRight - 2, sBottom - 4, sMid, sBottom);
    shieldPath.quadraticBezierTo(
      sLeft + 2,
      sBottom - 4,
      sLeft,
      sTop + (sBottom - sTop) * 0.55,
    );
    shieldPath.close();

    // Shield glow
    canvas.drawPath(
      shieldPath,
      Paint()
        ..color = const Color(0xFF06B6D4).withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
    );

    // Shield fill
    final shieldGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF22D3EE), Color(0xFF0D9488)],
    ).createShader(shieldPath.getBounds());
    canvas.drawPath(shieldPath, Paint()..shader = shieldGradient);

    // Shield border
    canvas.drawPath(
      shieldPath,
      Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    // White Checkmark
    final checkPath = Path();
    checkPath.moveTo(sMid - 6, sTop + (sBottom - sTop) * 0.40);
    checkPath.lineTo(sMid - 1, sTop + (sBottom - sTop) * 0.48);
    checkPath.lineTo(sMid + 7, sTop + (sBottom - sTop) * 0.30);
    canvas.drawPath(
      checkPath,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // 2. Detailed Sports Motorcycle in foreground
    final tirePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2;

    final rimPaint = Paint()..color = const Color(0xFF64748B);

    // Rear Wheel (left)
    final rearCenter = Offset(w * 0.22, h * 0.74);
    canvas.drawCircle(rearCenter, 8.5, tirePaint);
    canvas.drawCircle(rearCenter, 4.0, rimPaint);

    // Front Wheel (right)
    final frontCenter = Offset(w * 0.72, h * 0.74);
    canvas.drawCircle(frontCenter, 8.5, tirePaint);
    canvas.drawCircle(frontCenter, 4.0, rimPaint);

    // Frame & Engine
    final framePaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    // Swingarm from rear wheel to engine
    canvas.drawLine(rearCenter, Offset(w * 0.42, h * 0.68), framePaint);
    // Front fork
    canvas.drawLine(frontCenter, Offset(w * 0.62, h * 0.42), framePaint);

    // Engine block
    final engineRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.36, h * 0.60, w * 0.52, h * 0.76),
      const Radius.circular(3),
    );
    canvas.drawRRect(engineRect, Paint()..color = const Color(0xFF1E293B));

    // Chrome exhaust pipe
    final exhaustPaint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.42, h * 0.72),
      Offset(w * 0.16, h * 0.68),
      exhaustPaint,
    );

    // Sporty Fuel Tank & Seat Body
    final tankPath = Path();
    tankPath.moveTo(w * 0.30, h * 0.52); // seat
    tankPath.lineTo(w * 0.42, h * 0.52);
    tankPath.quadraticBezierTo(
      w * 0.50,
      h * 0.40,
      w * 0.58,
      h * 0.44,
    ); // tank hump
    tankPath.lineTo(w * 0.64, h * 0.44); // visor
    tankPath.lineTo(w * 0.62, h * 0.54);
    tankPath.lineTo(w * 0.44, h * 0.58);
    tankPath.close();

    final tankGradient = const LinearGradient(
      colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
    ).createShader(tankPath.getBounds());
    canvas.drawPath(tankPath, Paint()..shader = tankGradient);

    // Black Seat
    final seatRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.28, h * 0.50, w * 0.42, h * 0.55),
      const Radius.circular(2),
    );
    canvas.drawRRect(seatRect, Paint()..color = const Color(0xFF0F172A));

    // Handlebars & Headlight
    final barPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.60, h * 0.44),
      Offset(w * 0.56, h * 0.38),
      barPaint,
    );

    // Headlight glow
    canvas.drawCircle(
      Offset(w * 0.65, h * 0.48),
      2.0,
      Paint()..color = const Color(0xFF38BDF8),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -----------------------------------------------------------------------------
// 4. VEHICLE REPORT GRAPHIC
// -----------------------------------------------------------------------------
class VehicleReportGraphic extends StatelessWidget {
  final double width;
  final double height;
  final bool isDark;

  const VehicleReportGraphic({
    super.key,
    this.width = 48,
    this.height = 44,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _VehicleReportPainter(isDark: isDark)),
    );
  }
}

class _VehicleReportPainter extends CustomPainter {
  final bool isDark;
  _VehicleReportPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // 1. Clipboard Base
    final boardRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.12, h * 0.08, w * 0.78, h * 0.94),
      const Radius.circular(6),
    );
    canvas.drawRRect(
      boardRect,
      Paint()
        ..color = Colors.black.withOpacity(0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    final boardPaint = Paint()
      ..color = const Color(0xFF854D0E); // rich amber/wood
    canvas.drawRRect(boardRect, boardPaint);

    // 2. White Paper Document
    final paperRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.18, h * 0.15, w * 0.72, h * 0.88),
      const Radius.circular(3),
    );
    canvas.drawRRect(paperRect, Paint()..color = const Color(0xFFFFFFFF));
    canvas.drawRRect(
      paperRect,
      Paint()
        ..color = const Color(0xFFE2E8F0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // Header strip on paper
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.24, h * 0.20, w * 0.66, h * 0.25),
        const Radius.circular(1.5),
      ),
      Paint()..color = const Color(0xFF2563EB),
    );

    // Checklist Row 1 (Green check + line)
    final checkGreen = Paint()..color = const Color(0xFF10B981);
    canvas.drawCircle(Offset(w * 0.26, h * 0.35), 2.5, checkGreen);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.33, h * 0.33, w * 0.64, h * 0.37),
        const Radius.circular(1),
      ),
      Paint()..color = const Color(0xFF64748B),
    );

    // Checklist Row 2 (Green check + line)
    canvas.drawCircle(Offset(w * 0.26, h * 0.48), 2.5, checkGreen);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.33, h * 0.46, w * 0.58, h * 0.50),
        const Radius.circular(1),
      ),
      Paint()..color = const Color(0xFF64748B),
    );

    // Checklist Row 3 (Teal check + line)
    final checkTeal = Paint()..color = const Color(0xFF0D9488);
    canvas.drawCircle(Offset(w * 0.26, h * 0.61), 2.5, checkTeal);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.33, h * 0.59, w * 0.62, h * 0.63),
        const Radius.circular(1),
      ),
      Paint()..color = const Color(0xFF64748B),
    );

    // Checklist Row 4 (Orange check + line)
    final checkOrange = Paint()..color = const Color(0xFFF59E0B);
    canvas.drawCircle(Offset(w * 0.26, h * 0.74), 2.5, checkOrange);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.33, h * 0.72, w * 0.52, h * 0.76),
        const Radius.circular(1),
      ),
      Paint()..color = const Color(0xFF94A3B8),
    );

    // 3. Top Metallic Clamp
    final clampRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.33, h * 0.05, w * 0.57, h * 0.14),
      const Radius.circular(2.5),
    );
    canvas.drawRRect(clampRect, Paint()..color = const Color(0xFFCBD5E1));
    canvas.drawRRect(
      clampRect,
      Paint()
        ..color = const Color(0xFF64748B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
    // Center clamp rivet
    canvas.drawCircle(
      Offset(w * 0.45, h * 0.095),
      1.5,
      Paint()..color = const Color(0xFF475569),
    );

    // 4. Sharpened Inspection Pencil on right
    final pencilPath = Path();
    pencilPath.moveTo(w * 0.78, h * 0.24); // eraser top
    pencilPath.lineTo(w * 0.87, h * 0.28);
    pencilPath.lineTo(w * 0.72, h * 0.88); // tip base
    pencilPath.lineTo(w * 0.63, h * 0.84);
    pencilPath.close();

    // Pencil shadow
    canvas.drawShadow(pencilPath, Colors.black.withOpacity(0.2), 2, false);

    // Pencil yellow body
    canvas.drawPath(pencilPath, Paint()..color = const Color(0xFFF59E0B));

    // Pink eraser at top
    final eraserPath = Path();
    eraserPath.moveTo(w * 0.78, h * 0.24);
    eraserPath.lineTo(w * 0.87, h * 0.28);
    eraserPath.lineTo(w * 0.84, h * 0.36);
    eraserPath.lineTo(w * 0.75, h * 0.32);
    eraserPath.close();
    canvas.drawPath(eraserPath, Paint()..color = const Color(0xFFF472B6));

    // Graphite lead tip
    final tipPath = Path();
    tipPath.moveTo(w * 0.63, h * 0.84);
    tipPath.lineTo(w * 0.72, h * 0.88);
    tipPath.lineTo(w * 0.60, h * 0.96); // pointed lead
    tipPath.close();
    canvas.drawPath(tipPath, Paint()..color = const Color(0xFF1E293B));
  }

  @override
  bool shouldRepaint(covariant _VehicleReportPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

// -----------------------------------------------------------------------------
// 5. RC SEARCH GRAPHIC
// -----------------------------------------------------------------------------
class RcSearchGraphic extends StatelessWidget {
  final double width;
  final double height;
  final bool isDark;

  const RcSearchGraphic({
    super.key,
    this.width = 48,
    this.height = 44,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _RcSearchPainter(isDark: isDark)),
    );
  }
}

class _RcSearchPainter extends CustomPainter {
  final bool isDark;
  _RcSearchPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // 1. HSRP Indian Number Plate in background
    final plateRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.08, h * 0.26, w * 0.80, h * 0.68),
      const Radius.circular(4),
    );

    // Plate shadow
    canvas.drawRRect(
      plateRect,
      Paint()
        ..color = Colors.black.withOpacity(0.14)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // White plate background
    canvas.drawRRect(plateRect, Paint()..color = Colors.white);

    // Thin black border
    canvas.drawRRect(
      plateRect,
      Paint()
        ..color = const Color(0xFF0F172A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Blue IND strip on left
    final indStrip = RRect.fromRectAndCorners(
      Rect.fromLTRB(w * 0.08, h * 0.26, w * 0.26, h * 0.68),
      topLeft: const Radius.circular(4),
      bottomLeft: const Radius.circular(4),
    );
    canvas.drawRRect(indStrip, Paint()..color = const Color(0xFF1D4ED8));

    // Gold chakra dot on IND strip
    canvas.drawCircle(
      Offset(w * 0.17, h * 0.40),
      1.6,
      Paint()..color = const Color(0xFFFBBF24),
    );

    // "IND" white text line
    final whiteLine = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.13, h * 0.54),
      Offset(w * 0.21, h * 0.54),
      whiteLine,
    );

    // Registration characters monospace bars (representing DL 01 AB)
    final charPaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(w * 0.32, h * 0.42),
      Offset(w * 0.42, h * 0.42),
      charPaint,
    );
    canvas.drawLine(
      Offset(w * 0.32, h * 0.52),
      Offset(w * 0.42, h * 0.52),
      charPaint,
    );
    canvas.drawLine(
      Offset(w * 0.48, h * 0.42),
      Offset(w * 0.58, h * 0.42),
      charPaint,
    );
    canvas.drawLine(
      Offset(w * 0.48, h * 0.52),
      Offset(w * 0.58, h * 0.52),
      charPaint,
    );
    canvas.drawLine(
      Offset(w * 0.64, h * 0.42),
      Offset(w * 0.74, h * 0.42),
      charPaint,
    );
    canvas.drawLine(
      Offset(w * 0.64, h * 0.52),
      Offset(w * 0.74, h * 0.52),
      charPaint,
    );

    // 2. Magnifying Glass angled in foreground
    final lensCenter = Offset(w * 0.54, h * 0.42);
    final double lensRadius = w * 0.25;

    // Lens shadow
    canvas.drawCircle(
      lensCenter + const Offset(1, 2),
      lensRadius,
      Paint()
        ..color = Colors.black.withOpacity(0.20)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Glass lens fill (semi-transparent cyan tint)
    canvas.drawCircle(
      lensCenter,
      lensRadius - 2,
      Paint()..color = const Color(0x3806B6D4),
    );

    // Lens chrome/cyan rim
    final rimPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
      ).createShader(Rect.fromCircle(center: lensCenter, radius: lensRadius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2;
    canvas.drawCircle(lensCenter, lensRadius, rimPaint);

    // Specular glare across glass
    final glarePath = Path();
    glarePath.addArc(
      Rect.fromCircle(center: lensCenter, radius: lensRadius - 4),
      -math.pi * 0.75,
      math.pi * 0.45,
    );
    canvas.drawPath(
      glarePath,
      Paint()
        ..color = Colors.white.withOpacity(0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6
        ..strokeCap = StrokeCap.round,
    );

    // Glowing cyan Question Mark inside lens
    final qPath = Path();
    qPath.moveTo(lensCenter.dx - 4, lensCenter.dy - 5);
    qPath.cubicTo(
      lensCenter.dx - 4,
      lensCenter.dy - 10,
      lensCenter.dx + 4,
      lensCenter.dy - 10,
      lensCenter.dx + 4,
      lensCenter.dy - 5,
    );
    qPath.cubicTo(
      lensCenter.dx + 4,
      lensCenter.dy - 2,
      lensCenter.dx,
      lensCenter.dy - 1,
      lensCenter.dx,
      lensCenter.dy + 2,
    );

    canvas.drawPath(
      qPath,
      Paint()
        ..color = const Color(0xFF0284C7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(lensCenter.dx, lensCenter.dy + 5.5),
      1.3,
      Paint()..color = const Color(0xFF0284C7),
    );

    // Magnifying glass handle
    final handlePaint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final handleStart =
        lensCenter + Offset(lensRadius * 0.70, lensRadius * 0.70);
    final handleEnd = Offset(w * 0.92, h * 0.88);
    canvas.drawLine(handleStart, handleEnd, handlePaint);

    // Silver ferrule ring on handle
    final ferrulePaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      handleStart,
      handleStart +
          Offset(
            (handleEnd.dx - handleStart.dx) * 0.25,
            (handleEnd.dy - handleStart.dy) * 0.25,
          ),
      ferrulePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RcSearchPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

// -----------------------------------------------------------------------------
// 6. FASTAG GRAPHIC
// -----------------------------------------------------------------------------
class FastagGraphic extends StatelessWidget {
  final double width;
  final double height;
  final bool isDark;

  const FastagGraphic({
    super.key,
    this.width = 48,
    this.height = 44,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _FastagPainter(isDark: isDark)),
    );
  }
}

class _FastagPainter extends CustomPainter {
  final bool isDark;
  _FastagPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // FASTag RFID Card Sticker
    final cardRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.08, h * 0.16, w * 0.92, h * 0.84),
      const Radius.circular(5),
    );

    // Soft drop shadow
    canvas.drawRRect(
      cardRect,
      Paint()
        ..color = Colors.black.withOpacity(0.16)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Base card fill
    canvas.drawRRect(cardRect, Paint()..color = Colors.white);

    // Clip to rounded card for stripes
    canvas.save();
    canvas.clipRRect(cardRect);

    // 1. Top Stripe: Deep Saffron
    canvas.drawRect(
      Rect.fromLTRB(w * 0.08, h * 0.16, w * 0.92, h * 0.35),
      Paint()..color = const Color(0xFFFF7A00),
    );

    // 2. Middle Stripe: Pure White
    canvas.drawRect(
      Rect.fromLTRB(w * 0.08, h * 0.35, w * 0.92, h * 0.65),
      Paint()..color = Colors.white,
    );

    // 3. Bottom Stripe: Indian Green
    canvas.drawRect(
      Rect.fromLTRB(w * 0.08, h * 0.65, w * 0.92, h * 0.84),
      Paint()..color = const Color(0xFF138808),
    );

    // Middle Band Details:
    // Metallic Hologram Square on Left
    final holoRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.14, h * 0.40, w * 0.28, h * 0.60),
      const Radius.circular(1.5),
    );
    final holoGradient = const LinearGradient(
      colors: [Color(0xFF38BDF8), Color(0xFFA855F7), Color(0xFF34D399)],
    ).createShader(holoRect.outerRect);
    canvas.drawRRect(holoRect, Paint()..shader = holoGradient);

    // Stylized "FAST" in orange & "ag" in navy
    final fastPaint = Paint()
      ..color = const Color(0xFFE65100)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    // F
    canvas.drawLine(
      Offset(w * 0.34, h * 0.42),
      Offset(w * 0.34, h * 0.58),
      fastPaint,
    );
    canvas.drawLine(
      Offset(w * 0.34, h * 0.42),
      Offset(w * 0.42, h * 0.42),
      fastPaint,
    );
    canvas.drawLine(
      Offset(w * 0.34, h * 0.50),
      Offset(w * 0.40, h * 0.50),
      fastPaint,
    );
    // A
    canvas.drawLine(
      Offset(w * 0.44, h * 0.58),
      Offset(w * 0.48, h * 0.42),
      fastPaint,
    );
    canvas.drawLine(
      Offset(w * 0.48, h * 0.42),
      Offset(w * 0.52, h * 0.58),
      fastPaint,
    );
    canvas.drawLine(
      Offset(w * 0.45, h * 0.52),
      Offset(w * 0.51, h * 0.52),
      fastPaint,
    );

    // "ag" in deep navy
    final agPaint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    // T
    canvas.drawLine(
      Offset(w * 0.54, h * 0.42),
      Offset(w * 0.62, h * 0.42),
      agPaint,
    );
    canvas.drawLine(
      Offset(w * 0.58, h * 0.42),
      Offset(w * 0.58, h * 0.58),
      agPaint,
    );

    // RFID radio wave broadcast arcs )))
    final wavePaint = Paint()
      ..color = const Color(0xFF0284C7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final arcCenter = Offset(w * 0.68, h * 0.50);
    canvas.drawArc(
      Rect.fromCircle(center: arcCenter, radius: 4),
      -math.pi * 0.35,
      math.pi * 0.70,
      false,
      wavePaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: arcCenter, radius: 7),
      -math.pi * 0.35,
      math.pi * 0.70,
      false,
      wavePaint,
    );

    // Diagonal glossy specular highlight
    final sheenPath = Path();
    sheenPath.moveTo(w * 0.08, h * 0.84);
    sheenPath.lineTo(w * 0.48, h * 0.16);
    sheenPath.lineTo(w * 0.62, h * 0.16);
    sheenPath.lineTo(w * 0.22, h * 0.84);
    sheenPath.close();
    canvas.drawPath(sheenPath, Paint()..color = Colors.white.withOpacity(0.22));

    canvas.restore();

    // Card border
    canvas.drawRRect(
      cardRect,
      Paint()
        ..color = const Color(0xFFCBD5E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );
  }

  @override
  bool shouldRepaint(covariant _FastagPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

// -----------------------------------------------------------------------------
// 7. CAR CHECK GRAPHIC (OPEN HOOD + ENGINE DIAGNOSTICS)
// -----------------------------------------------------------------------------
class CarCheckGraphic extends StatelessWidget {
  final double width;
  final double height;
  final bool isDark;

  const CarCheckGraphic({
    super.key,
    this.width = 48,
    this.height = 44,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _CarCheckPainter(isDark: isDark)),
    );
  }
}

class _CarCheckPainter extends CustomPainter {
  final bool isDark;
  _CarCheckPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    final double carLeft = w * 0.08;
    final double carRight = w * 0.92;
    final double carBottom = h * 0.92;
    final double carMid = (carLeft + carRight) / 2;

    // 1. Car Shadow
    canvas.drawOval(
      Rect.fromLTRB(carLeft - 2, carBottom - 3, carRight + 2, carBottom + 4),
      Paint()
        ..color = Colors.black.withOpacity(0.22)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Wheels
    final wheelPaint = Paint()..color = const Color(0xFF0F172A);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(carLeft + 2, carBottom - 7, carLeft + 8, carBottom + 2),
        const Radius.circular(2),
      ),
      wheelPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(carRight - 8, carBottom - 7, carRight - 2, carBottom + 2),
        const Radius.circular(2),
      ),
      wheelPaint,
    );

    // Car Body / Bumper
    final bodyPath = Path();
    bodyPath.moveTo(carLeft + 4, h * 0.55);
    bodyPath.lineTo(carRight - 4, h * 0.55);
    bodyPath.lineTo(carRight, h * 0.70);
    bodyPath.lineTo(carRight, carBottom - 3);
    bodyPath.quadraticBezierTo(carMid, carBottom, carLeft, carBottom - 3);
    bodyPath.lineTo(carLeft, h * 0.70);
    bodyPath.close();

    final bodyGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFFFF), Color(0xFFCBD5E1)],
    ).createShader(bodyPath.getBounds());
    canvas.drawPath(bodyPath, Paint()..shader = bodyGradient);

    canvas.drawPath(
      bodyPath,
      Paint()
        ..color = const Color(0xFF64748B)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.9,
    );

    // Headlights
    final lightPaint = Paint()..color = const Color(0xFF38BDF8);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(carLeft + 4, h * 0.62, carLeft + 11, h * 0.68),
        const Radius.circular(2),
      ),
      lightPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(carRight - 11, h * 0.62, carRight - 4, h * 0.68),
        const Radius.circular(2),
      ),
      lightPaint,
    );

    // Grille & Plate
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(carMid - 8, h * 0.64, carMid + 8, h * 0.76),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF1E293B),
    );

    // 2. Open Engine Bay
    final engineBayRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(carLeft + 6, h * 0.40, carRight - 6, h * 0.56),
      const Radius.circular(3),
    );
    canvas.drawRRect(engineBayRect, Paint()..color = const Color(0xFF0F172A));

    // Engine cylinder block
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(carMid - 8, h * 0.42, carMid + 8, h * 0.54),
        const Radius.circular(2),
      ),
      Paint()..color = const Color(0xFF475569),
    );
    // Battery with amber/cyan terminals
    canvas.drawRect(
      Rect.fromLTRB(carLeft + 8, h * 0.44, carLeft + 14, h * 0.52),
      Paint()..color = const Color(0xFFF59E0B),
    );

    // 3. Open Hood Propped Upwards at 35 degrees
    final hoodPath = Path();
    hoodPath.moveTo(carLeft + 4, h * 0.40);
    hoodPath.lineTo(carLeft + 8, h * 0.10); // propped up top-left
    hoodPath.lineTo(carRight - 10, h * 0.16); // propped top-right
    hoodPath.lineTo(carRight - 4, h * 0.40);
    hoodPath.close();

    final hoodGradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFE2E8F0), Color(0xFF94A3B8)],
    ).createShader(hoodPath.getBounds());
    canvas.drawPath(hoodPath, Paint()..shader = hoodGradient);

    canvas.drawPath(
      hoodPath,
      Paint()
        ..color = const Color(0xFF475569)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Hood support prop rod
    final rodPaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(carRight - 12, h * 0.22),
      Offset(carRight - 8, h * 0.44),
      rodPaint,
    );

    // 4. Chrome Mechanic Wrench diagnosing the engine
    final wrenchPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round;

    // Diagonal wrench over engine
    final wStart = Offset(w * 0.32, h * 0.28);
    final wEnd = Offset(w * 0.68, h * 0.48);
    canvas.drawLine(wStart, wEnd, wrenchPaint);

    // Wrench open-jaw head
    canvas.drawCircle(wStart, 3.2, Paint()..color = const Color(0xFF38BDF8));
    canvas.drawCircle(wStart, 1.6, Paint()..color = Colors.white);

    // Sparkle glint
    canvas.drawCircle(
      Offset(w * 0.34, h * 0.26),
      1.0,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _CarCheckPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}

// -----------------------------------------------------------------------------
// 8. CAR LOAN / FINANCING GRAPHIC
// -----------------------------------------------------------------------------
class CarLoanGraphic extends StatelessWidget {
  final double width;
  final double height;
  final bool isDark;

  const CarLoanGraphic({
    super.key,
    this.width = 48,
    this.height = 44,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _CarLoanPainter(isDark: isDark)),
    );
  }
}

class _CarLoanPainter extends CustomPainter {
  final bool isDark;
  _CarLoanPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;

    // 1. Layered Emerald Currency Note in background
    final notePath = Path();
    notePath.moveTo(w * 0.08, h * 0.20);
    notePath.lineTo(w * 0.72, h * 0.12);
    notePath.lineTo(w * 0.76, h * 0.52);
    notePath.lineTo(w * 0.12, h * 0.60);
    notePath.close();

    // Note shadow
    canvas.drawShadow(notePath, Colors.black.withOpacity(0.18), 3, false);

    // Note green gradient
    final noteGradient = const LinearGradient(
      colors: [Color(0xFF10B981), Color(0xFF047857)],
    ).createShader(notePath.getBounds());
    canvas.drawPath(notePath, Paint()..shader = noteGradient);

    // Note white border
    canvas.drawPath(
      notePath,
      Paint()
        ..color = Colors.white.withOpacity(0.7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // Note watermark oval
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.42, h * 0.35), width: 14, height: 9),
      Paint()..color = Colors.white.withOpacity(0.2),
    );

    // 2. Stack of Golden Indian Rupee Coins in foreground
    final double coinW = w * 0.50;
    final double coinH = h * 0.22;
    final double coinX = w * 0.44;

    // Bottom Coin
    _drawGoldCoin(
      canvas,
      Offset(coinX, h * 0.74),
      coinW,
      coinH,
      hasRupee: false,
    );

    // Middle Coin
    _drawGoldCoin(
      canvas,
      Offset(coinX, h * 0.64),
      coinW,
      coinH,
      hasRupee: false,
    );

    // Top Coin with bold ₹ Glyph
    _drawGoldCoin(
      canvas,
      Offset(coinX, h * 0.52),
      coinW,
      coinH,
      hasRupee: true,
    );

    // 3. Mini Vehicle Key & Remote Fob on left
    final fobRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.06, h * 0.58, w * 0.26, h * 0.90),
      const Radius.circular(4),
    );
    canvas.drawRRect(fobRect, Paint()..color = const Color(0xFF1E293B));
    canvas.drawRRect(
      fobRect,
      Paint()
        ..color = const Color(0xFF475569)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    // Lock/Unlock buttons on key fob
    canvas.drawCircle(
      Offset(w * 0.16, h * 0.68),
      2.2,
      Paint()..color = const Color(0xFF38BDF8),
    );
    canvas.drawCircle(
      Offset(w * 0.16, h * 0.78),
      2.0,
      Paint()..color = const Color(0xFF94A3B8),
    );

    // Metallic key blade extending from top of fob
    final bladePaint = Paint()
      ..color = const Color(0xFFCBD5E1)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(w * 0.16, h * 0.58),
      Offset(w * 0.16, h * 0.46),
      bladePaint,
    );
  }

  void _drawGoldCoin(
    Canvas canvas,
    Offset center,
    double width,
    double height, {
    required bool hasRupee,
  }) {
    final rect = Rect.fromCenter(center: center, width: width, height: height);

    // Coin 3D edge / rim
    final edgeRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + 3.0),
      width: width,
      height: height,
    );
    canvas.drawOval(edgeRect, Paint()..color = const Color(0xFFB45309));

    // Coin top surface
    final coinGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFDE047), Color(0xFFF59E0B), Color(0xFFD97706)],
    ).createShader(rect);

    canvas.drawOval(rect, Paint()..shader = coinGradient);

    // Embossed inner rim
    final innerRect = Rect.fromCenter(
      center: center,
      width: width * 0.82,
      height: height * 0.78,
    );
    canvas.drawOval(
      innerRect,
      Paint()
        ..color = const Color(0xFFB45309).withOpacity(0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8,
    );

    if (hasRupee) {
      // Bold ₹ Glyph in center
      final rPaint = Paint()
        ..color = const Color(0xFF78350F)
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round;

      final cx = center.dx;
      final cy = center.dy;

      // Top bar
      canvas.drawLine(
        Offset(cx - 4.5, cy - 3.2),
        Offset(cx + 4.5, cy - 3.2),
        rPaint,
      );
      // Second bar
      canvas.drawLine(
        Offset(cx - 4.5, cy - 1.2),
        Offset(cx + 3.5, cy - 1.2),
        rPaint,
      );
      // R curve & leg
      final rPath = Path();
      rPath.moveTo(cx - 2.5, cy - 3.2);
      rPath.lineTo(cx - 2.5, cy + 0.5);
      rPath.quadraticBezierTo(cx + 2.0, cy + 0.5, cx + 2.0, cy - 1.5);
      rPath.quadraticBezierTo(cx + 2.0, cy - 3.2, cx - 2.5, cy - 3.2);
      rPath.moveTo(cx - 1.0, cy + 0.5);
      rPath.lineTo(cx + 4.0, cy + 4.0);
      canvas.drawPath(
        rPath,
        Paint()
          ..color = const Color(0xFF78350F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.4
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CarLoanPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
