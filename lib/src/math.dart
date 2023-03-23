// ignore_for_file: constant_identifier_names

import 'dart:math' as math;

/// The [Math] class provides a collection of common mathematical constants,
/// functions and utilities, inspired by the dart:math library. This class
/// provides additional functionality, such as methods for generating
/// pseudo-random values and a function for mapping a value from one range
/// to another.
class Math {
  static final math.Random _rnd = math.Random();

  /// A mathematical constant for the ratio of the circumference of a circle
  /// to its diameter, expressed as `pi`, with a value of ~3.141592653589793.
  static const PI = math.pi;

  /// Shortcut for `Math.PI * 2`, represents a 360 degree angle
  static const PI_2 = math.pi * 2;

  /// Shortcut for `Math.PI/2`, represents an angle of 90 degrees in radians.
  static const PI1_2 = math.pi / 2;

  /// A mathematical constant for the base of natural logarithms,
  /// expressed as `e`.
  static const E = math.e;

  /// A mathematical constant for the natural logarithm of 10,
  /// expressed as `loge10`, with an approximate value of 2.302585092994046.
  static const LN10 = math.ln10;

  /// A mathematical constant for the natural logarithm of 2,
  /// expressed as `loge2`, with an approximate value of 0.6931471805599453.
  static const LN2 = math.ln2;

  /// A mathematical constant for the base-10 logarithm of the constant `e`
  /// (Math.E), expressed as `log10e`, with an approximate value of
  /// 0.4342944819032518.
  static const LOG10E = math.log10e;

  /// A mathematical constant for the base-2 logarithm of the constant `e`,
  /// expressed as `log2e`, with an approximate value of 1.442695040888963387.
  static const LOG2E = math.log2e;

  /// A mathematical constant for the square root of one-half,
  /// with an approximate value of 0.7071067811865476.
  static const SQRT1_2 = math.sqrt1_2;

  /// A mathematical constant for the square root of 2,
  /// with an approximate value of 1.4142135623730951.
  static const SQRT2 = math.sqrt2;

  /// Computes and returns the cosine of the specified angle in radians.
  static const cos = math.cos;

  /// Computes and returns the arc cosine of the number specified in the
  /// parameter `x`, in radians.
  static const acos = math.acos;

  /// Computes and returns the sine of the specified angle in radians.
  static const sin = math.sin;

  /// Computes and returns the arc sine of the number specified in the
  /// parameter `x`, in radians.
  static const asin = math.asin;

  /// Computes and returns the tangent of the specified angle.
  /// Shortcut of [math.tan]
  static const tan = math.tan;

  /// Computes and returns the value, in radians, of the angle whose tangent
  /// is specified in the parameter `x`.
  /// Shortcut of [math.atan]
  static const atan = math.atan;

  /// Computes and returns the angle of the point a/b in radians,
  /// in cartesian coordinates `a=y`, and `b=x`.
  /// when measured counterclockwise from a circle's x axis
  /// (where 0,0 represents the center of the circle).
  static const atan2 = math.atan2;

  /// Computes and returns the square root of 'x'.
  static const sqrt = math.sqrt;

  /// Returns the value of the base of the natural logarithm (e),
  /// to the power of the exponent specified in the parameter `x`.
  static const exp = math.exp;

  /// Returns the natural logarithm of the parameter `x`.
  static const log = math.log;

  /// Evaluates `a` and `b` and returns the largest value.
  static const max = math.max;

  /// Evaluates `a` and `b` and returns the smallest value.
  static const min = math.min;

  /// Computes and returns `x` to the power of `exponent`.
  static const pow = math.pow;

  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory Math() {
    throw UnsupportedError(
      "Cannot instantiate Math. Use only static methods.",
    );
  }

  // * OLD code
  // static final max = m.max as T Function<T extends num>(T, T);

  /// Private constructor to prevent instantiation
  Math._();

  /// Computes and returns an absolute value for the number specified by
  /// [value].
  @pragma("vm:prefer-inline")
  static T abs<T extends num>(T value) {
    return value.abs() as T;
  }

  /// Returns the ceiling of the specified [value] or expression.
  /// Parameter [keepDouble] enforces the return type to be `double`.
  @pragma("vm:prefer-inline")
  static num ceil(double value, [bool keepDouble = true]) {
    return keepDouble ? value.ceilToDouble() : value.ceil();
  }

  /// Computes the dot product of two 2D vectors.
  ///
  /// Given the `(x, y)` coordinates of four points, `(x0, y0)`, `(x1, y1)`,
  /// `(x2, y2)`, and `(x3, y3)`, computes the dot product of the vector
  /// `(dx0, dy0)` and `(dx1, dy1)`.
  @pragma("vm:prefer-inline")
  static double dotProduct(
    double x0,
    double y0,
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) {
    var dx0 = x1 - x0, dy0 = y1 - y0, dx1 = x3 - x2, dy1 = y3 - y2;
    return dx0 * dx1 + dy0 * dy1;
  }

  /// Returns the floor of the number or expression specified in the parameter
  /// [value].
  /// Parameter [keepDouble] enforces the return type to be `double`.
  @pragma("vm:prefer-inline")
  static num floor(double value, [bool keepDouble = true]) {
    return keepDouble ? value.floorToDouble() : value.floor();
  }

  /// Linearly interpolates a value within a given range.
  ///
  /// Given a [min] and [max] range and a [t] value between 0 and 1, returns a
  /// linearly interpolated value within the [min]-[max] range.
  ///
  /// Example:
  /// ```dart
  /// final min = 0;
  /// final max = 100;
  /// final t = 0.5;
  /// final interpolatedValue = Math.lerp(min, max, t);
  /// print(interpolatedValue); // 50
  /// ```
  @pragma("vm:prefer-inline")
  static double lerp(num min, num max, double t) {
    return min + (max - min) * t;
  }

  /// Log base 10
  static double log10(num value) {
    return math.log(value) * math.log10e;
  }

  /// Maps a value from one range to another.
  ///
  /// Given a [srcValue], [srcMin], [srcMax], [dstMin], and [dstMax], maps the
  /// [srcValue] from the [srcMin]-[srcMax] range to the [dstMin]-[dstMax]
  /// range.
  ///
  /// Example:
  /// ```dart
  /// final srcValue = 50;
  /// final srcMin = 0;
  /// final srcMax = 100;
  /// final dstMin = 0;
  /// final dstMax = 255;
  /// final mappedValue = Math.map(srcValue, srcMin, srcMax, dstMin, dstMax);
  /// print(mappedValue); // 127.5
  /// ```
  @pragma("vm:prefer-inline")
  static double map(
    double srcValue,
    double srcMin,
    double srcMax,
    double dstMin,
    double dstMax,
  ) {
    final norm = Math.norm(srcValue, srcMin, srcMax);
    return Math.lerp(dstMin, dstMax, norm);
  }

  /// Normalizes a value within a given range.
  ///
  /// Given a [value], [min] and [max], returns a normalized value between 0
  /// and 1, representing the position of the [value] within the [min]-[max]
  /// range.
  ///
  /// Example:
  /// ```dart
  /// final value = 50;
  /// final min = 0;
  /// final max = 100;
  /// final normalizedValue = Math.norm(value, min, max);
  /// print(normalizedValue); // 0.5
  /// ```
  @pragma("vm:prefer-inline")
  static double norm(num value, num min, num max) {
    return (value - min) / (max - min);
  }

  /// Returns a pseudo-random double n, where 0 <= n < 1.
  /// Using the [math.Random] class.
  @pragma("vm:prefer-inline")
  static double random() {
    return _rnd.nextDouble();
  }

  /// Returns a pseudo-random boolean (true or false).
  /// Using the [math.Random] class.
  @pragma("vm:prefer-inline")
  static bool randomBool() {
    return _rnd.nextBool();
  }

  /// Returns a pseudo-random element `<E>` from the parameter [list].
  /// Using the `Random()` class to compute the List index.
  @pragma("vm:prefer-inline")
  static E randomList<E>(List<E> list) {
    return list[randomRangeInt(0, list.length)];
  }

  /// Returns a pseudo-random `double` number between parameters `min` and
  /// `max`.
  /// Doesn't check for errors: Parameters can not be `null`;
  /// And `min` > `max`.
  @pragma("vm:prefer-inline")
  static double randomRange(num min, num max) {
    return min.toDouble() + random() * (max.toDouble() - min.toDouble());
  }

  /// Returns a pseudo-random `double` number between parameters `min` and
  /// `max`, clamping the returned value to `clamp`.
  /// Doesn't check for errors: Parameters can not be `null`;
  /// And `min` > `max`.
  @pragma("vm:prefer-inline")
  static double randomRangeClamp(num min, num max, num clamp) {
    return (randomRange(min.toDouble(), max.toDouble()) / clamp.toDouble())
            .roundToDouble() *
        clamp.toDouble();
  }

  /// Returns a pseudo-random `int` number between parameters `min` and `max`.
  /// Doesn't check for errors: Parameters can not be `null`;
  /// And `min` > `max`.
  @pragma("vm:prefer-inline")
  static int randomRangeInt(num min, num max) {
    return min.toInt() + _rnd.nextInt(max.toInt() - min.toInt());
  }

  /// Returns a pseudo-random `int` number between parameters `min` and
  /// `max`, clamping the returned value to `clamp`.
  /// Doesn't check for errors: Parameters can not be `null`;
  /// And `min` > `max`.
  @pragma("vm:prefer-inline")
  static int randomRangeIntClamp(num min, num max, num clamp) {
    return (randomRangeInt(min.toInt(), max.toInt()) / clamp.toInt()).round() *
        clamp.toInt();
  }

  /// Rounds the [value]up or down to the nearest integer and returns the value.
  /// Parameter [keepDouble] enforces the return type to be `double`.
  @pragma("vm:prefer-inline")
  static num round(double value, [bool keepDouble = true]) {
    return keepDouble ? value.roundToDouble() : value.round();
  }
}
