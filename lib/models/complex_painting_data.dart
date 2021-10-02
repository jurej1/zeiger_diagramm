import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:zeiger_diagramm/models/models.dart';

class ComplexPaintingObject extends Equatable {
  final Complex complex;
  final Color lineColor;

  const ComplexPaintingObject(
    this.complex, {
    this.lineColor = Colors.black,
  });

  @override
  List<Object> get props => [complex, lineColor];

  ComplexPaintingObject copyWith({
    Complex? complex,
    Color? lineColor,
  }) {
    return ComplexPaintingObject(
      complex ?? this.complex,
      lineColor: lineColor ?? this.lineColor,
    );
  }
}
