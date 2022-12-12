// ignore_for_file: constant_identifier_names

import 'dart:math' as m;

abstract class Math {
  static final m.Random _rnd = m.Random();

  /// A mathematical constant for the ratio of the circumference of a circle
  /// to its diameter, expressed as `pi`, with a value of ~3.141592653589793.
  static const PI = m.pi;

  /// Shortcut for `Math.PI * 2`, represents a 360 degree angle
  static const PI_2 = m.pi * 2;

  /// Shortcut for `Math.PI/2`, represents an angle of 90 degrees in radians.
  static const PI1_2 = m.pi / 2;

  /// A mathematical constant for the base of natural logarithms,
  /// expressed as `e`.
  static const E = m.e;

  /// A mathematical constant for the natural logarithm of 10,
  /// expressed as `loge10`, with an approximate value of 2.302585092994046.
  static const LN10 = m.ln10;

  /// A mathematical constant for the natural logarithm of 2,
  /// expressed as `loge2`, with an approximate value of 0.6931471805599453.
  static const LN2 = m.ln2;

  /// A mathematical constant for the base-10 logarithm of the constant `e`
  /// (Math.E), expressed as `log10e`, with an approximate value of
  /// 0.4342944819032518.
  static const LOG10E = m.log10e;

  /// A mathematical constant for the base-2 logarithm of the constant `e`,
  /// expressed as `log2e`, with an approximate value of 1.442695040888963387.
  static const LOG2E = m.log2e;

  /// A mathematical constant for the square root of one-half,
  /// with an approximate value of 0.7071067811865476.
  static const SQRT1_2 = m.sqrt1_2;

  /// A mathematical constant for the square root of 2,
  /// with an approximate value of 1.4142135623730951.
  static const SQRT2 = m.sqrt2;

  /// Computes and returns the cosine of the specified angle in radians.
  static const cos = m.cos;

  /// Computes and returns the arc cosine of the number specified in the
  /// parameter `x`, in radians.
  static const acos = m.acos;

  /// Computes and returns the sine of the specified angle in radians.
  static const sin = m.sin;

  /// Computes and returns the arc sine of the number specified in the
  /// parameter `x`, in radians.
  static const asin = m.asin;

  /// Computes and returns the tangent of the specified angle.
  /// Shortcut of [math.tan]
  static const tan = m.tan;

  /// Computes and returns the value, in radians, of the angle whose tangent
  /// is specified in the parameter `x`.
  /// Shortcut of [dart:math atan()]
  static const atan = m.atan;

  /// Computes and returns the angle of the point a/b in radians,
  /// in cartesian coordinates `a=y`, and `b=x`.
  /// when measured counterclockwise from a circle's x axis
  /// (where 0,0 represents the center of the circle).
  static const atan2 = m.atan2;

  /// Computes and returns the square root of 'x'.
  static const sqrt = m.sqrt;

  /// Returns the value of the base of the natural logarithm (e),
  /// to the power of the exponent specified in the parameter `x`.
  static const exp = m.exp;

  /// Returns the natural logarithm of the parameter `x`.
  static const log = m.log;

  /// Log base 10
  static double log10(num value){
    return m.log(value) * m.log10e;
  }

  /// Evaluates `a` and `b` and returns the largest value.
  static const max = m.max;
  // * OLD code
  // static final max = m.max as T Function<T extends num>(T, T);

  /// Evaluates `a` and `b` and returns the smallest value.
  static const min = m.min;

  /// Computes and returns `x` to the power of `exponent`.
  static const pow = m.pow;

  /// Returns the ceiling of the specified number or expression.
  /// Parameter `keepDouble` enforces the return type to be `double`.
  static num ceil(double value, [bool keepDouble = true]) {
    return keepDouble ? value.ceilToDouble() : value.ceil();
  }

  /// Returns the floor of the number or expression specified in the parameter
  /// `value`.
  /// Parameter `keepDouble` enforces the return type to be `double`.
  static num floor(double value, [bool keepDouble = true]) {
    return keepDouble ? value.floorToDouble() : value.floor();
  }

  /// Rounds the value of the parameter `value` up or down to the nearest
  /// integer and returns the value.
  /// Parameter `keepDouble` enforces the return type to be `double`.
  static num round(double value, [bool keepDouble = true]) {
    return keepDouble ? value.roundToDouble() : value.round();
  }

  /// Computes and returns an absolute value for the number specified by
  /// the parameter `value`.
  static num abs(num value) => value.abs();

  /// Returns a pseudo-random boolean (true or false).
  /// Using the `Random()` class.
  static bool randomBool() => _rnd.nextBool();

  /// Returns a pseudo-random double n, where 0 <= n < 1.
  /// Using the `Random()` class.
  static double random() => _rnd.nextDouble();

  /// Returns a pseudo-random element `<E>` from the parameter `list`.
  /// Using the `Random()` class to compute the List index.
  static E randomList<E>(List<E> list) => list[randomRangeInt(0, list.length)];

  /// Returns a pseudo-random `double` number between parameters `min` and
  /// `max`.
  /// Doesn't check for errors: Parameters can not be `null`;
  /// And `min` > `max`.
  static double randomRange(num min, num max) =>
      min.toDouble() + random() * (max.toDouble() - min.toDouble());

  /// Returns a pseudo-random `int` number between parameters `min` and `max`.
  /// Doesn't check for errors: Parameters can not be `null`;
  /// And `min` > `max`.
  static int randomRangeInt(num min, num max) =>
      min.toInt() + _rnd.nextInt(max.toInt() - min.toInt());

  /// Returns a pseudo-random `double` number between parameters `min` and
  /// `max`, clamping the returned value to `clamp`.
  /// Doesn't check for errors: Parameters can not be `null`;
  /// And `min` > `max`.
  static double randomRangeClamp(num min, num max, num clamp) =>
      (randomRange(min.toDouble(), max.toDouble()) / clamp.toDouble())
          .roundToDouble() *
      clamp.toDouble();

  /// Returns a pseudo-random `int` number between parameters `min` and
  /// `max`, clamping the returned value to `clamp`.
  /// Doesn't check for errors: Parameters can not be `null`;
  /// And `min` > `max`.
  static int randomRangeIntClamp(num min, num max, num clamp) =>
      (randomRangeInt(min.toInt(), max.toInt()) / clamp.toInt()).round() *
      clamp.toInt();

  static double norm(num value, num min, num max) {
    return (value - min) / (max - min);
  }

  static double lerp(num min, num max, double t) {
    return min + (max - min) * t;
  }
}
