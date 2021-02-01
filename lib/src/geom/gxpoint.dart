import 'dart:math' as math;
import 'dart:ui';

class GPoint {
  static GPoint fromNative(Offset nativeOffset) {
    return GPoint(nativeOffset.dx, nativeOffset.dy);
  }

  @override
  String toString() {
    return 'GxPoint {$x,$y}';
  }

  GPoint clone() => GPoint(x, y);

  Offset toNative() => Offset(x, y);

  GPoint setEmpty() {
    x = y = 0.0;
    return this;
  }

  GPoint setTo(double x, double y) {
    this.x = x;
    this.y = y;
    return this;
  }

  double x, y;
  GPoint([this.x = 0, this.y = 0]);

  static double distance(GPoint p1, GPoint p2) {
    var dx = p2.x - p1.x;
    var dy = p2.y - p1.y;
    dx *= dx;
    dy *= dy;
    return math.sqrt(dx + dy);
  }

  double get length => math.sqrt(x * x + y * y);
}
