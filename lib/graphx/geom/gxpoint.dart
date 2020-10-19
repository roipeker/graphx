import 'dart:math' as math;
import 'dart:ui';

class GxPoint {
  static GxPoint fromNative(Offset nativeOffset) {
    return GxPoint(nativeOffset.dx, nativeOffset.dy);
  }

  Offset toNative() {
    return Offset(x, y);
  }

  double x, y;
  GxPoint([this.x, this.y]);

  static double distance(GxPoint p1, GxPoint p2) {
    var dx = p2.x - p1.x;
    var dy = p2.y - p1.y;
    dx *= dx;
    dy *= dy;
    return math.sqrt(dx + dy);
  }

  double get length => math.sqrt(x * x + y * y);
}
