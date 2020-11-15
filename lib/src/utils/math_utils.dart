import 'dart:math' as math;

import 'package:vector_math/vector_math_64.dart';

import '../../graphx.dart';

double deg2rad(double deg) => deg / 180.0 * math.pi;
double rad2deg(double rad) => rad / math.pi * 180.0;

abstract class MathUtils {
  static const double halfPi = math.pi / 2;
  static const double pi2 = math.pi * 2;

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

  static double normalizeAngle(double angle) {
    angle = angle % pi2;
    if (angle < -math.pi) angle += pi2;
    if (angle > math.pi) angle -= pi2;
    return angle;
  }

  static bool isPointInTriangle(GxPoint p, GxPoint a, GxPoint b, GxPoint c) {
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

  /// Calculates the intersection point between the xy-plane and an infinite
  /// line that is defined by two 3D points in the same coordinate system.
  static GxPoint intersectLineWithXYPlane(Vector3 pointA, Vector3 pointB,
      [GxPoint out]) {
    out ??= GxPoint();
    final vectorX = pointB.x - pointA.x;
    final vectorY = pointB.y - pointA.y;
    final vectorZ = pointB.z - pointA.z;
    final lambda = -pointA.z / vectorZ;
    out.x = pointA.x + lambda * vectorX;
    out.y = pointA.y + lambda * vectorY;
    return out;
  }

  static bool isEquivalent(double a, double b, [double epsilon = .0001]) =>
      (a - epsilon < b) && (a + epsilon > b);

  static double shortRotation(double rotation) {
    if (rotation < -math.pi) {
      rotation += pi2;
    } else if (rotation > math.pi) {
      rotation -= pi2;
    }
    return rotation;
  }
}
