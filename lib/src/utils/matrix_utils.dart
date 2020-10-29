import 'dart:math' as math;

import '../../graphx/geom/gxmatrix.dart';
import '../../graphx/geom/gxrect.dart';

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

  static GxRect getTransformedBoundsRect(GxMatrix matrix, GxRect rect,
      [GxRect out]) {
    out ??= GxRect();
    //      out = out.getBounds(matrix);
//      return out;
    double minX = 10000000.0;
    double maxX = -10000000.0;
    double minY = 10000000.0;
    double maxY = -10000000.0;
    double tx1 = matrix.a * rect.x + matrix.c * rect.y + matrix.tx;
    double ty1 = matrix.d * rect.y + matrix.b * rect.x + matrix.ty;
    double tx2 = matrix.a * rect.x + matrix.c * rect.bottom + matrix.tx;
    double ty2 = matrix.d * rect.bottom + matrix.b * rect.x + matrix.ty;
    double tx3 = matrix.a * rect.right + matrix.c * rect.y + matrix.tx;
    double ty3 = matrix.d * rect.y + matrix.b * rect.right + matrix.ty;
    double tx4 = matrix.a * rect.right + matrix.c * rect.bottom + matrix.tx;
    double ty4 = matrix.d * rect.bottom + matrix.b * rect.right + matrix.ty;
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
