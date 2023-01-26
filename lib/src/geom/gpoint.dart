import 'dart:math' as math;
import 'dart:ui';

import '../math.dart';

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

  // Determines a point between two specified points.
  static GPoint interpolate(GPoint a, GPoint b, double f) {
    return GPoint(a.x + f * (b.x - a.x), a.y + f * (b.y - a.y));
  }

  // Converts a pair of polar coordinates to a Cartesian point coordinate.
  static GPoint polar(double length, double angle) {
    return GPoint(Math.cos(angle) * length, Math.sin(angle) * length);
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

  // Sets the members of Point to 0
  GPoint setEmpty() {
    x = y = 0.0;
    return this;
  }

  // Adds the coordinates of another point to the coordinates of this point
  // to create a new point.
  GPoint add(GPoint o) {
    return GPoint(x + o.x, y + o.y);
  }

  // Subtracts the coordinates of another point from the coordinates of this
  // point to create a new point.
  GPoint subtract(GPoint o) {
    return GPoint(x - o.x, y - o.y);
  }

  /// Sets the members of GPoint to the specified values
  GPoint setTo(double x, double y) {
    this.x = x;
    this.y = y;
    return this;
  }

  // Determines whether two points are equal.
  bool equals(GPoint o) => x == o.x && y == o.y;

  /// The horizontal coordinate of the point.
  double x;

  /// The vertical coordinate of the point.
  double y;

  /// create a new GPoint instance.
  GPoint([this.x = 0, this.y = 0]);

  /// The length of the line segment from (0,0) to this point.
  double get length => math.sqrt(x * x + y * y);

  /// == Mutators ==
  /// The following methods modify the current point.

  // Scales the line segment between (0,0) and the current point to a set length.
  void normalize(double thickness) {
    if (y == 0) {
      x = x < 0 ? -thickness : thickness;
    } else if (x == 0) {
      y = y < 0 ? -thickness : thickness;
    } else {
      var m = thickness / Math.sqrt(x * x + y * y);
      x *= m;
      y *= m;
    }
  }

  // Offsets the Point object by the specified amount.
  void offset(double dx, double dy) {
    x += dx;
    y += dy;
  }
}
