// import 'dart:math' as math;
// import 'package:vector_math/vector_math_64.dart';
import '../../graphx.dart';

/// Converts an angle in degrees to radians.
///
/// The resulting angle is calculated by dividing the input angle deg by 180
/// and then multiplying it by [Math.PI].
///
/// For example, deg2rad(90) returns approximately 1.5708, which is
/// equivalent to 90 degrees in radians.
@pragma("vm:prefer-inline")
double deg2rad(double deg) {
  return deg / 180.0 * Math.PI;
}

// Converts an angle in radians to degrees.
///
/// The resulting angle is calculated by dividing the input angle rad by
/// [Math.PI] and then multiplying it by 180.
///
/// For example, rad2deg(1.5708) returns approximately 90, which is
/// equivalent to pi/2 radians in degrees.
@pragma("vm:prefer-inline")
double rad2deg(double rad) {
  return rad / Math.PI * 180.0;
}

/// A collection of static utility methods for mathematical operations.
///
class MathUtils {
  /// Half of the value of pi.
  static const double halfPi = Math.PI / 2;

  /// The value of 2 times pi.
  static const double pi2 = Math.PI * 2;

  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory MathUtils() {
    throw UnsupportedError(
      "Cannot instantiate MathUtils. Use only static methods.",
    );
  }

  /// Private constructor to prevent instantiation
  MathUtils._();

  /// Calculates the next power of two for the given [value].
  /// If [value] is already a power of two, it is returned.
  /// If [value] is not a power of two, the smallest power of two
  /// greater than [value] is returned.
  static int getNextPowerOfTwo(num value) {
    if (value is int &&
        value > 0 &&
        (value.toInt() & (value.toInt() - 1)) == 0) {
      return value;
    } else {
      var result = 1;
      value -= 0.000000001; // avoid floating point rounding errors
      while (result < value) {
        result <<= 1;
      }
      return result;
    }
  }

  /// Determines if two floating-point numbers are equivalent within a given
  /// epsilon value.
  ///
  /// Returns true if the absolute difference between the two numbers is less
  static bool isEquivalent(double a, double b, [double epsilon = .0001]) {
    return (a - epsilon < b) && (a + epsilon > b);
  }

  /// Determines whether a given [point] is inside a triangle defined by three
  /// other points ([a], [b], [c]).
  static bool isPointInTriangle(GPoint p, GPoint a, GPoint b, GPoint c) {
    // This algorithm is described well in this article:
    // http://www.blackpawn.com/texts/pointinpoly/default.html
    var v0x = c.x - a.x;
    var v0y = c.y - a.y;
    var v1x = b.x - a.x;
    var v1y = b.y - a.y;
    var v2x = p.x - a.x;
    var v2y = p.y - a.y;

    var dot00 = v0x * v0x + v0y * v0y;
    var dot01 = v0x * v1x + v0y * v1y;
    var dot02 = v0x * v2x + v0y * v2y;
    var dot11 = v1x * v1x + v1y * v1y;
    var dot12 = v1x * v2x + v1y * v2y;

    final invDen = 1.0 / (dot00 * dot11 - dot01 * dot01);
    final u = (dot11 * dot02 - dot01 * dot12) * invDen;
    final v = (dot00 * dot12 - dot01 * dot02) * invDen;
    return (u >= 0) && (v >= 0) && (u + v < 1);
  }

  /// Normalizes the given [angle] (in radians) to the range of -pi to pi.
  static double normalizeAngle(double angle) {
    angle = angle % pi2;
    if (angle < -Math.PI) {
      angle += pi2;
    }
    if (angle > Math.PI) {
      angle -= pi2;
    }
    return angle;
  }

  /// Shortens the given [rotation] angle to the range of -pi to pi.
  static double shortRotation(double rotation) {
    if (rotation < -Math.PI) {
      rotation += pi2;
    } else if (rotation > Math.PI) {
      rotation -= pi2;
    }
    return rotation;
  }
}
