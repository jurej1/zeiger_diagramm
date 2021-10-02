import 'dart:math';

import 'package:equatable/equatable.dart';
import 'dart:math' as math;

class Complex extends Equatable {
  final double real;
  final double imaginary;

  const Complex(this.real, [this.imaginary = 0]);

  factory Complex.valueAngleDegree(double value, [double angle = 0]) {
    assert(angle >= 0 && angle <= 360 || angle <= 0 && angle >= -360);

    if (angle.isNegative) {
      angle = 360 + angle;
    }

    final radians = angle * (math.pi / 180);

    return Complex(
      value * math.cos(radians),
      value * math.sin(radians),
    );
  }

  factory Complex.valueAngleRadians(double value, [double radians = 0]) {
    assert(radians >= 0 && radians <= math.pi * 2);
    return Complex(
      value * math.cos(radians),
      value * math.sin(radians),
    );
  }

  @override
  List<Object> get props => [real, imaginary];

  double get absoluteValue {
    final a = real * real;
    final b = imaginary * imaginary;
    return math.sqrt(a + b);
  }

  double get angle {
    final val = imaginary / real;
    double angle = math.atan(val);
    if (imaginary.isNegative) {
      return angle - pi * 1.5;
    } else if (real.isNegative) {
      return angle - pi / 2;
    } else {
      return -angle;
    }
  }

  double mapValue(double x, double inMin, double inMax, double outMin, double outMax) {
    return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
  }
}
