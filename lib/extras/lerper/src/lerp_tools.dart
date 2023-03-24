part of lerper;

class LerpTools {
  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory LerpTools() {
    throw UnsupportedError(
      "Cannot instantiate LerpTools. Use only static methods.",
    );
  }

  /// Private constructor to prevent instantiation
  LerpTools._();

  static final _rnd = math.Random();

  @pragma('vm:prefer-inline')
  static double spread(double rate, double scale) {
    return lerp(rate, -scale, scale);
  }

  @pragma('vm:prefer-inline')
  static double shake(
    double rate, [
    double center = 0,
    double Function()? randomCallback,
  ]) {
    return center + spread((randomCallback ?? _rnd.nextDouble)(), rate);
  }

  @pragma('vm:prefer-inline')
  static double sin(double rate) {
    return math.sin(rate * EasingTools.pi2);
  }

  @pragma('vm:prefer-inline')
  static double cos(double rate) {
    return math.cos(rate * EasingTools.pi2);
  }

  @pragma('vm:prefer-inline')
  static double revert(double rate) {
    return 1 - rate;
  }

  /* Clamps a `value` between `min` and `max`. */
  static double clamp(double value, [double min = 0.0, double max = 1.0]) {
    if (value <= min) {
      return min;
    } else if (value >= max) {
      return max;
    } else {
      return value;
    }
  }

  @pragma('vm:prefer-inline')
  static double lerp(num rate, num from, num to) {
    return from * (1.0 - rate) + to * rate.toDouble();
  }

  @pragma('vm:prefer-inline')
  static double inverseLerp(num value, num from, num to) {
    return (value - from) / (to - from);
  }

  @pragma('vm:prefer-inline')
  static double mixEasing(
    double rate,
    EaseFun easing1,
    EaseFun easing2, [
    double easing2Strength = 0.5,
  ]) {
    return easing2Strength.lerp(easing1(rate), easing2(rate));
  }

  @pragma('vm:prefer-inline')
  static double crossfadeEasing(
    double rate,
    EaseFun easing1,
    EaseFun easing2,
    EaseFun easing2StrengthEasing, [
    double easing2StrengthStart = 0,
    double easing2StrengthEnd = 1,
  ]) {
    return easing2StrengthEasing(rate)
        .lerp(easing2StrengthStart, easing2StrengthEnd)
        .lerp(easing1(rate), easing2(rate));
  }

  @pragma('vm:prefer-inline')
  static double connectEasing(
    double time,
    EaseFun easing1,
    EaseFun easing2, [
    double switchTime = 0.5,
    double switchValue = 0.5,
  ]) {
    return (time < switchTime)
        ? //
        easing1(time.invLerp(0, switchTime)).lerp(0, switchValue)
        : //
        easing2(time.invLerp(switchTime, 1)).lerp(switchValue, 1);
  }

  @pragma('vm:prefer-inline')
  static double yoyo(double rate, EaseFun ease) {
    return (rate < 0.5) ? ease(rate * 2) : ease((1 - rate) * 2);
  }

  @pragma('vm:prefer-inline')
  static double reverse(double rate, EaseFun ease) {
    return (rate < 0.5) ? ease(rate * 2) : (1 - ease((rate - .5) * 2));
  }

  /// quadratic
  @pragma('vm:prefer-inline')
  static double bezier2(double rate, double from, double control, double to) {
    return lerp(rate, lerp(rate, from, control), lerp(rate, control, to));
  }

  @pragma('vm:prefer-inline')
  static double _evaluateCubic(double a, double b, double m) {
    return 3 * a * (1 - m) * (1 - m) * m + 3 * b * (1 - m) * m * m + m * m * m;
  }

  /// Flutter's `Cubic`.
  @pragma('vm:prefer-inline')
  static double cubic(
    double rate,
    double a,
    double b,
    double c,
    double d, [
    double resolution = .001,
  ]) {
    double start = 0.0;
    double end = 1.0;
    while (true) {
      final double midpoint = (start + end) / 2;
      final double estimate = _evaluateCubic(a, c, midpoint);
      if ((rate - estimate).abs() < resolution) {
        return _evaluateCubic(b, d, midpoint);
      }
      if (estimate < rate) {
        start = midpoint;
      } else {
        end = midpoint;
      }
    }
  }

  /// cubic
  @pragma('vm:prefer-inline')
  static double bezier3(
    double rate,
    double from,
    double control1,
    double control2,
    double to,
  ) {
    return bezier2(
      rate,
      lerp(rate, from, control1),
      lerp(rate, control1, control2),
      lerp(rate, control2, to),
    );
  }

  @pragma('vm:prefer-inline')
  static double bezier(double rate, Iterable<double> values) {
    if (values.length < 2) {
      throw "points length must be more than 2";
    } else if (values.length == 2) {
      return lerp(rate, values.first, values.last);
    } else if (values.length == 3) {
      return bezier2(rate, values.first, values.elementAt(1), values.last);
    } else {
      return _bezier(rate, values);
    }
  }

  static double _bezier(double rate, Iterable<double> values) {
    if (values.length == 4) {
      return bezier3(rate, values.first, values.elementAt(1),
          values.elementAt(2), values.last);
    }
    final iterValues = values.toList(growable: false);
    final newLen = values.length - 1;
    final output = List.filled(values.length - 1, 0.0);
    for (var i = 0; i < newLen; ++i) {
      output[i] = lerp(rate, iterValues[i], iterValues[i + 1]);
    }
    return _bezier(rate, output);
  }

  static double uniformQuadBSpline(double rate, Iterable<double> values) {
    if (values.length < 2) {
      throw "points length must be more than 2";
    }
    if (values.length == 2) {
      return lerp(rate, values.first, values.last);
    }
    final max = values.length - 2;
    final scaledRate = rate * max;
    final index = scaledRate.floor().clamp(0, max - 1);
    final innerRate = scaledRate - index;
    final p0 = values.elementAt(index);
    final p1 = values.elementAt(index + 1);
    final p2 = values.elementAt(index + 2);
    return innerRate * innerRate * (p0 / 2 - p1 + p2 / 2) +
        innerRate * (-p0 + p1) +
        p0 / 2;
  }

  @pragma('vm:prefer-inline')
  static double polyline(double rate, List<double> values) {
    if (values.length < 2) {
      throw "points length must be more than 2";
    } else {
      final max = values.length - 1;
      final scaledRate = rate * max;
      final index = scaledRate.clamp(0, max - 1).floor();
      return lerp(scaledRate - index, values[index], values[index + 1]);
    }
  }
}


// class GPointTools {
//   static GPoint polyline(double rate, List<GPoint> points, [GPoint? output]) {
//     output ??= GPoint(0,0);
//     var x = <double>[];
//     var y = <double>[];
//     for (var p in points) {
//       x.add(p.x);
//       y.add(p.y);
//     }
//     output.x = rate.polyline(x);
//     output.y = rate.polyline(y);
//     return output;
//   }
// }

/// expose constants easing functions for LerpTools functions like
/// [LerpTools.yoyo] and [LerpTools.reverse].

const linear = EasingTools.linear;
const sineIn = EasingTools.sineIn;
const sineOut = EasingTools.sineOut;
const sineInOut = EasingTools.sineInOut;
const sineOutIn = EasingTools.sineOutIn;

const quadIn = EasingTools.quadIn;
const quadOut = EasingTools.quadOut;
const quadInOut = EasingTools.quadInOut;
const quadOutIn = EasingTools.quadOutIn;

const cubicIn = EasingTools.cubicIn;
const cubicOut = EasingTools.cubicOut;
const cubicInOut = EasingTools.cubicInOut;
const cubicOutIn = EasingTools.cubicOutIn;

const quintIn = EasingTools.quintIn;
const quintOut = EasingTools.quintOut;
const quintInOut = EasingTools.quintInOut;
const quintOutIn = EasingTools.quintOutIn;

const expoIn = EasingTools.expoIn;
const expoOut = EasingTools.expoOut;
const expoInOut = EasingTools.expoInOut;
const expoOutIn = EasingTools.expoOutIn;

const circIn = EasingTools.circIn;
const circOut = EasingTools.circOut;
const circInOut = EasingTools.circInOut;
const circOutIn = EasingTools.circOutIn;

const bounceIn = EasingTools.bounceIn;
const bounceOut = EasingTools.bounceOut;
const bounceInOut = EasingTools.bounceInOut;
const bounceOutIn = EasingTools.bounceOutIn;

const backIn = EasingTools.backIn;
const backOut = EasingTools.backOut;
const backInOut = EasingTools.backInOut;
const backOutIn = EasingTools.backOutIn;

const elasticIn = EasingTools.elasticIn;
const elasticOut = EasingTools.elasticOut;
const elasticInOut = EasingTools.elasticInOut;
const elasticOutIn = EasingTools.elasticOutIn;

const warpIn = EasingTools.warpIn;
const warpOut = EasingTools.warpOut;
const warpInOut = EasingTools.warpInOut;
const warpOutIn = EasingTools.warpOutIn;

// Gives back an `EaseFun` callback transform, useful for [LerpTools.yoyo]
EaseFun easeCubic(double a, b, c, d) => (double rate) => rate.cubic(a, b, c, d);

// Make an instance with the configuration for a Cubic Bezier.
// useful for [LerpTools.yoyo].
// ```
//  double time = (getTimer() * .004);
//  final easeCubic = CubicParams(0.25, 0.1, 0.25, 1.0);
//  box.x = time.yoyo(easeCubic).lerp(0, 100);
// ```
class CubicParams {
  final double a, b, c, d;

  const CubicParams(this.a, this.b, this.c, this.d);

  double call(double rate) => rate.cubic(a, b, c, d);
}
