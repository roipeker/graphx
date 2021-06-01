import 'dart:math' as math;
import 'dart:ui';

/// The GPoint object represents a location in a two-dimensional coordinate
/// system, where `x` represents the horizontal axis and `y` represents the
/// vertical axis.
/// The following code creates a point at (0,0):
///
/// ```dart
/// var myPoint:Point = new Point();
/// ```

class GPoint {
  /// Returns the distance between p1 and p2.
  static double distance(GPoint p1, GPoint p2) {
    var dx = p2.x - p1.x;
    var dy = p2.y - p1.y;
    dx *= dx;
    dy *= dy;
    return math.sqrt(dx + dy);
  }

  /// Creates a point instance from an dart `Offset`.
  static GPoint fromNative(Offset nativeOffset) =>
      GPoint(nativeOffset.dx, nativeOffset.dy);

  /// Returns a string that contains the values of the x and y coordinates.
  @override
  String toString() => 'GPoint {$x,$y}';

  /// Creates a copy of this GPoint object.
  GPoint clone() => GPoint(x, y);

  /// Creates a `Offset` instance (Dart primitive) from this GPoint.
  Offset toNative() => Offset(x, y);

  GPoint setEmpty() {
    x = y = 0.0;
    return this;
  }

  /// Sets the members of GPoint to the specified values
  GPoint setTo(double x, double y) {
    this.x = x;
    this.y = y;
    return this;
  }

  /// The horizontal coordinate of the point.
  double x;

  /// The vertical coordinate of the point.
  double y;

  /// create a new GPoint instance.
  GPoint([this.x = 0, this.y = 0]);

  /// The length of the line segment from (0,0) to this point.
  double get length => math.sqrt(x * x + y * y);
}
