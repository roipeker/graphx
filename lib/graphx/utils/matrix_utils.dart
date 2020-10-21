import 'dart:math' as math;

import 'package:graphx/graphx/geom/gxmatrix.dart';

abstract class MatrixUtils {
  static void skew(GxMatrix matrix, double skewX, double skewY) {
    var sinX = math.sin(skewX);
    var cosX = math.cos(skewX);
    var sinY = math.sin(skewY);
    var cosY = math.cos(skewY);
    matrix.setTo(
      matrix.a * cosY - matrix.b * sinX,
      matrix.a * sinY + matrix.b * cosX,
      matrix.c * cosY - matrix.d * sinX,
      matrix.c * sinY + matrix.d * cosX,
      matrix.tx * cosY - matrix.ty * sinX,
      matrix.tx * sinY + matrix.ty * cosX,
    );
  }
}
