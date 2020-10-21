import 'dart:math' as math;
import 'dart:ui';

class GxPoint {
  static GxPoint fromNative(Offset nativeOffset) {
    return GxPoint(nativeOffset.dx, nativeOffset.dy);
  }

  @override
  String toString() {
    return 'GxPoint {$x,$y}';
  }

  Offset toNative() {
    return Offset(x, y);
  }

  GxPoint setTo(double x, double y) {
    this.x = x;
    this.y = y;
    return this;
  }

  double x, y;
  GxPoint([this.x = 0, this.y = 0]);

  static double distance(GxPoint p1, GxPoint p2) {
    var dx = p2.x - p1.x;
    var dy = p2.y - p1.y;
    dx *= dx;
    dy *= dy;
    return math.sqrt(dx + dy);
  }

//  GxPointek]pqr3
//  Point.prototype.dot = function (p) {
//    var result = ((this.x*p.x)+(this.y*p.y));
//    return result;
//  };
//
//  Point.prototype.cross = function (p) {
//    var result = ((this.x*p.y)-(this.y*p.x));
//    return result;
//  };

  double get length => math.sqrt(x * x + y * y);
}
