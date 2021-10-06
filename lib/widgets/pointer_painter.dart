import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:zeiger_diagramm/models/models.dart';

class PointerPainter extends CustomPainter {
  final Paint achsesPaint = Paint()
    ..color = Colors.black
    ..strokeWidth = 4;

  final List<ComplexPaintingObject> spannungen;
  final double maxValue;
  final double animationValue;

  PointerPainter({
    this.animationValue = 0.0,
    this.spannungen = const [],
  }) : maxValue = spannungen
            .reduce((value, element) => value.complex.absoluteValue.abs() > element.complex.absoluteValue.abs() ? value : element)
            .complex
            .absoluteValue
            .abs();

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    drawAchses(canvas, size, center);

    drawSpannungen(canvas, size, center);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  void drawAchses(Canvas canvas, Size size, Offset center) {
    // x achse
    Offset p1X = center.translate(-size.width * 0.4, 0);
    Offset p2X = center.translate(size.width * 0.4, 0);
    canvas.drawLine(p1X, p2X, achsesPaint);

    //y achse
    Offset p1Y = center.translate(0, -size.height * 0.4);
    Offset p2Y = center.translate(0, size.height * 0.4);
    canvas.drawLine(p1Y, p2Y, achsesPaint);
  }

  void drawSpannung(Canvas canvas, Size size, Offset center, ComplexPaintingObject spannung) {
    final double maxRadius = size.width * 0.4;

    final double absValue = spannung.complex.absoluteValue;

    double mappedAbsValue = mapValueToFit(absValue, 0, maxValue, 0, maxRadius);

    double angle = spannung.complex.angle;

    double x = cos(2 * pi - animationValue + angle) * mappedAbsValue;
    double y = sin(2 * pi - animationValue + angle) * mappedAbsValue;

    dev.log(spannung.complex.angle.toString());

    final endPoint = Offset(
      center.dx + (x),
      center.dy + (y),
    );

    canvas.drawLine(
      center,
      endPoint,
      Paint()
        ..color = spannung.lineColor
        ..strokeWidth = 5,
    );

    TextSpan span = TextSpan(text: spannung.name);
    TextPainter tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    tp.paint(canvas, endPoint);
  }

  double mapValueToFit(double x, double inMin, double inMax, double outMin, double outMax) {
    return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
  }

  void drawSpannungen(Canvas canvas, Size size, Offset center) {
    for (int i = 0; i < spannungen.length; i++) {
      drawSpannung(canvas, size, center, spannungen[i]);
    }
  }
}
