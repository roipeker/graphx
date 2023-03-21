import 'dart:math' as math;
import 'dart:ui';

import '../math.dart';

/// The [GPoint] object represents a location in a two-dimensional coordinate
/// system, where [x] represents the horizontal axis and [y] represents the
/// vertical axis.
///
/// The following code creates a point at (0,0):
///
/// ```dart
/// final myPoint = GPoint();
/// ```
///
class GPoint {
  /// The horizontal coordinate of the point.
  double x;

  /// The vertical coordinate of the point.
  double y;

  /// Creates a new [GPoint] instance with the specified [x] and [y]
  /// coordinates.
  ///
  /// If no coordinates are specified, the point defaults to (0, 0).
  GPoint([this.x = 0, this.y = 0]);

  /// The length of a line segment from (0,0) to this point.
  double get length {
    return math.sqrt(x * x + y * y);
  }

  /// Adds the coordinates of another [point] to the coordinates of this point
  /// and returns the result as a new point.
  ///
  /// For instance, if this point is (2, 3) and the other [point] is (1, 4),
  /// the resulting point will be (3, 7).
  GPoint add(GPoint point) {
    return GPoint(x + point.x, y + point.y);
  }

  /// Creates a copy of this [GPoint] object.
  GPoint clone() {
    return GPoint(x, y);
  }

  /// Checks if this [GPoint] is equal to another [GPoint] by comparing their x
  /// and y coordinates.
  /// Returns true if they are equal, otherwise false.
  bool equals(GPoint point) {
    return x == point.x && y == point.y;
  }

  /// Multiply the coordinates of this [GPoint] by given dx and dy values.
  void multiply([double dx = 1, double dy = 1]) {
    x *= dx;
    y *= dy;
  }

  /// === Mutators ===
  /// The following methods modify the current point.

  /// Normalizes the [GPoint] to have the specified [thickness] but keeping its
  /// direction.
  ///
  /// If the point is at the origin, it will be set to the positive x-axis
  /// direction or the positive y-axis direction (depending on which component
  /// is zero).
  ///
  /// If the point is not at the origin, it will be scaled to have the specified
  /// thickness while keeping its direction.
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

  /// Offsets this point's coordinates by [dx] along the x-axis and by [dy]
  /// along the y-axis.
  void offset(double dx, double dy) {
    x += dx;
    y += dy;
  }

  /// Sets the `x` and `y` values of this point to zero.
  ///
  /// Returns the updated [GPoint] instance.
  GPoint setEmpty() {
    x = y = 0.0;
    return this;
  }

  /// Sets the x and y values of this [GPoint] to the provided [x] and [y]
  /// values respectively.
  GPoint setTo(double x, double y) {
    this.x = x;
    this.y = y;
    return this;
  }

  /// Subtracts the coordinates of another point from the coordinates of this
  /// point to create a new point.
  GPoint subtract(GPoint point) {
    return GPoint(x - point.x, y - point.y);
  }

  /// Creates a Dart [Offset] instance from this [GPoint].
  Offset toNative() {
    return Offset(x, y);
  }

  /// Returns a string that contains the values of the x and y coordinates.
  @override
  String toString() {
    return 'GPoint {$x,$y}';
  }

  /// Returns the distance between [p1] and [p2].
  static double distance(GPoint p1, GPoint p2) {
    var dx = p2.x - p1.x;
    var dy = p2.y - p1.y;
    dx *= dx;
    dy *= dy;
    return math.sqrt(dx + dy);
  }

  /// Creates a point instance from an dart [Offset].
  static GPoint fromNative(Offset nativeOffset) {
    return GPoint(nativeOffset.dx, nativeOffset.dy);
  }

  /// Returns the point that is at the position specified by the interpolation
  /// factor [f] between points [a] and [b].
  ///
  /// The [f] parameter represents the position of the interpolation between the
  /// two points as a value between 0.0 and 1.0, where 0.0 represents point [a],
  /// 1.0 represents point [b], and values between 0.0 and 1.0 represent points
  /// that are linearly interpolated between [a] and [b].
  static GPoint interpolate(GPoint a, GPoint b, double f) {
    return GPoint(a.x + f * (b.x - a.x), a.y + f * (b.y - a.y));
  }

  /// Returns a new [GPoint] object in polar coordinates based on a length and
  /// an angle.
  ///
  /// The [length] parameter specifies the distance from the origin (0,0), and
  /// the [angle] parameter specifies the angle of the vector in radians, with 0
  /// pointing to the right and increasing in the counterclockwise direction.
  /// Returns a [GPoint] object with x and y coordinates calculated from the
  /// polar coordinates.
  static GPoint polar(double length, double angle) {
    return GPoint(Math.cos(angle) * length, Math.sin(angle) * length);
  }
}
