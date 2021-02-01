// import 'dart:math' as math;

import '../../graphx.dart';

abstract class MatrixUtils {
  static void skew(GMatrix matrix, double skewX, double skewY) {
    var sinX = Math.sin(skewX);
    var cosX = Math.cos(skewX);
    var sinY = Math.sin(skewY);
    var cosY = Math.cos(skewY);
    matrix.setTo(
      matrix.a * cosY - matrix.b * sinX,
      matrix.a * sinY + matrix.b * cosX,
      matrix.c * cosY - matrix.d * sinX,
      matrix.c * sinY + matrix.d * cosX,
      matrix.tx * cosY - matrix.ty * sinX,
      matrix.tx * sinY + matrix.ty * cosX,
    );
  }

  static GRect getTransformedBoundsRect(GMatrix matrix, GRect rect,
      [GRect out]) {
    out ??= GRect();
    var minX = 10000000.0;
    var maxX = -10000000.0;
    var minY = 10000000.0;
    var maxY = -10000000.0;
    var tx1 = matrix.a * rect.x + matrix.c * rect.y + matrix.tx;
    var ty1 = matrix.d * rect.y + matrix.b * rect.x + matrix.ty;
    var tx2 = matrix.a * rect.x + matrix.c * rect.bottom + matrix.tx;
    var ty2 = matrix.d * rect.bottom + matrix.b * rect.x + matrix.ty;
    var tx3 = matrix.a * rect.right + matrix.c * rect.y + matrix.tx;
    var ty3 = matrix.d * rect.y + matrix.b * rect.right + matrix.ty;
    var tx4 = matrix.a * rect.right + matrix.c * rect.bottom + matrix.tx;
    var ty4 = matrix.d * rect.bottom + matrix.b * rect.right + matrix.ty;
    if (minX > tx1) minX = tx1;
    if (minX > tx2) minX = tx2;
    if (minX > tx3) minX = tx3;
    if (minX > tx4) minX = tx4;
    if (minY > ty1) minY = ty1;
    if (minY > ty2) minY = ty2;
    if (minY > ty3) minY = ty3;
    if (minY > ty4) minY = ty4;
    if (maxX < tx1) maxX = tx1;
    if (maxX < tx2) maxX = tx2;
    if (maxX < tx3) maxX = tx3;
    if (maxX < tx4) maxX = tx4;
    if (maxY < ty1) maxY = ty1;
    if (maxY < ty2) maxY = ty2;
    if (maxY < ty3) maxY = ty3;
    if (maxY < ty4) maxY = ty4;
    out.setTo(minX, minY, maxX - minX, maxY - minY);
    return out;
  }
}
