part of lerper;

typedef EaseFun = double Function(double rate);

/// A collection of static methods for easing functions used in animations.
class EasingTools {
  /// Factory constructor to ensure exception. Throws an exception if an attempt
  /// is made to instantiate this class.
  factory EasingTools() {
    throw UnsupportedError(
      "Cannot instantiate EasingTools. Use only static methods.",
    );
  }

  /// Private constructor to prevent instantiation
  EasingTools._();

  /// The constant value of PI.
  @pragma('vm:prefer-inline')
  static const pi = 3.1415926535897932384626433832795;

  /// Half of the constant value of PI.
  @pragma('vm:prefer-inline')
  static const double piHalf = pi / 2;

  /// The constant value of 2 times PI.
  @pragma('vm:prefer-inline')
  static const double pi2 = pi * 2;

  /// The natural logarithm of 2.
  @pragma('vm:prefer-inline')
  static const double ln2 = 0.6931471805599453;

  /// The natural logarithm of 10 times the natural logarithm of 2.
  @pragma('vm:prefer-inline')
  static const double ln2_10 = 6.931471805599453;

  // === LINEAR ===

  /// Returns a linear interpolation of [t].
  ///
  /// This is the default easing curve and returns the same value as [t].
  ///
  /// [t] must be a value between 0.0 and 1.0.
  @pragma('vm:prefer-inline')
  static double linear(double t) {
    return t;
  }

  // === SINE ===

  /// Returns an easing curve that starts slowly and accelerates as [t] increases.
  ///
  /// This is an easing curve that approximates a sine wave.
  /// The curve starts very slowly and then accelerates as [t] increases.
  /// It reaches full speed at t=1.0.
  ///
  /// [t] must be a value between 0.0 and 1.0.
  @pragma('vm:prefer-inline')
  static double sineIn(double t) {
    if (t == 0) return 0;
    if (t == 1) return 1;
    return 1 - math.cos(t * pi / 2);
  }

  /// Returns an easing curve that ends slowly and decelerates as [t] increases.
  ///
  /// This is an easing curve that approximates the inverse of a sine wave.
  /// The curve starts at full speed and then slows down as [t] increases.
  /// It reaches zero speed at t=1.0.
  ///
  /// [t] must be a value between 0.0 and 1.0.
  @pragma('vm:prefer-inline')
  static double sineOut(double t) {
    if (t == 0) return 0;
    if (t == 1) return 1;
    return math.sin(t * piHalf);
  }

  /// Returns an easing curve that starts and ends slowly, and accelerates in the middle.
  ///
  /// This is an easing curve that approximates a combination of a sine wave and its inverse.
  /// The curve starts and ends very slowly and then accelerates in the middle.
  ///
  /// [t] must be a value between 0.0 and 1.0.
  @pragma('vm:prefer-inline')
  static double sineInOut(double t) {
    if (t == 0) {
      return 0;
    } else if (t == 1) {
      return 1;
    } else {
      return -0.5 * (math.cos(pi * t) - 1);
    }
  }

  /// Applies a sine easing out-in effect to the input value [t].
  ///
  /// The output starts by easing out and then eases in towards the end.
  ///
  /// - [t]: The input value. Must be between 0 and 1 (inclusive).
  ///
  /// Returns the eased output value.
  @pragma('vm:prefer-inline')
  static double sineOutIn(double t) {
    if (t == 0) {
      return 0;
    } else if (t == 1) {
      return 1;
    } else if (t < 0.5) {
      return 0.5 * math.sin((t * 2) * piHalf);
    } else {
      return -0.5 * math.cos((t * 2 - 1) * piHalf) + 1;
    }
  }

  // === QUAD ===

  /// Eases a value into a quadratic curve.
  ///
  /// The interpolation starts slow and speeds up, creating a smooth and
  /// natural motion. This function takes a value between 0 and 1 and returns a
  /// new value between 0 and 1 that has been eased using a quadratic function.
  ///
  /// The curve starts at (0, 0) and ends at (1, 1).
  @pragma('vm:prefer-inline')
  static double quadIn(double t) {
    return t * t;
  }

  /// Eases a value out of a quadratic curve.
  ///
  /// The interpolation starts fast and slows down, creating a smooth and
  /// natural motion. This function takes a value between 0 and 1 and returns a
  /// new value between 0 and 1 that has been eased using a quadratic function.
  ///
  /// The curve starts at (0, 0) and ends at (1, 1).
  @pragma('vm:prefer-inline')
  static double quadOut(double t) {
    return -t * (t - 2);
  }

  /// Eases a value into and out of a quadratic curve.
  ///
  /// The interpolation starts slow, speeds up, then slows down again, creating
  /// a smooth and natural motion. This function takes a value between 0 and 1
  /// and returns a new value between 0 and 1 that has been eased using a
  /// quadratic function.
  ///
  /// The curve starts at (0, 0) and ends at (1, 1).
  @pragma('vm:prefer-inline')
  static double quadInOut(double t) {
    return (t < .5) ? t * t * 2 : (-2 * t * (t - 2) - 1);
  }

  /// Eases a value into and out of a quadratic curve, then out and back into
  /// another quadratic curve.
  ///
  /// The interpolation starts slow, speeds up, then slows down again, creating
  /// a smooth and natural motion. The curve then reverses and follows the same
  /// pattern for the remaining half of the animation. This function takes a
  /// value between 0 and 1 and returns a new value between 0 and 1 that has
  /// been eased using a combination of two quadratic functions.
  ///
  @pragma('vm:prefer-inline')
  static double quadOutIn(double t) {
    return (t < 0.5)
        ? -0.5 * (t = (t * 2)) * (t - 2)
        : 0.5 * (t = (t * 2 - 1)) * t + 0.5;
  }

  /// === CUBIC ===
  @pragma('vm:prefer-inline')
  static double cubicIn(double t) => t * t * t;

  @pragma('vm:prefer-inline')
  static double cubicOut(double t) {
    return (--t) * t * t + 1;
  }

  @pragma('vm:prefer-inline')
  static double cubicInOut(double t) {
    return ((t *= 2) < 1) ? 0.5 * t * t * t : 0.5 * ((t -= 2) * t * t + 2);
  }

  @pragma('vm:prefer-inline')
  static double cubicOutIn(double t) {
    return 0.5 * ((t = t * 2 - 1) * t * t + 1);
  }

  /// === QUART ===
  @pragma('vm:prefer-inline')
  static double quartIn(double t) {
    return (t *= t) * t;
  }

  @pragma('vm:prefer-inline')
  static double quartOut(double t) {
    return 1 - (t = (t = t - 1) * t) * t;
  }

  @pragma('vm:prefer-inline')
  static double quartInOut(double t) {
    return ((t *= 2) < 1)
        ? 0.5 * (t *= t) * t
        : -0.5 * ((t = (t -= 2) * t) * t - 2);
  }

  @pragma('vm:prefer-inline')
  static double quartOutIn(double t) {
    return (t < 0.5)
        ? -0.5 * (t = (t = t * 2 - 1) * t) * t + 0.5
        : 0.5 * (t = (t = t * 2 - 1) * t) * t + 0.5;
  }

  /// === QUINT ===
  @pragma('vm:prefer-inline')
  static double quintIn(double t) {
    return t * (t *= t) * t;
  }

  @pragma('vm:prefer-inline')
  static double quintOut(double t) {
    return (t = t - 1) * (t *= t) * t + 1;
  }

  @pragma('vm:prefer-inline')
  static double quintInOut(double t) {
    return ((t *= 2) < 1)
        ? 0.5 * t * (t *= t) * t
        : 0.5 * (t -= 2) * (t *= t) * t + 1;
  }

  @pragma('vm:prefer-inline')
  static double quintOutIn(double t) {
    return 0.5 * ((t = t * 2 - 1) * (t *= t) * t + 1);
  }

  /// === EXPONENTIAL ===
  /// Uses pow() or Logarithmic Curve.
  @pragma('vm:prefer-inline')
  static double expoIn(double t) {
    // return math.pow(2, 10 * (t - 1)).toDouble();
    return t == 0 ? 0 : math.exp(ln2_10 * (t - 1));
  }

  @pragma('vm:prefer-inline')
  static double expoOut(double t) {
    return t == 1 ? 1 : (1 - math.exp(-ln2_10 * t));
  }

  @pragma('vm:prefer-inline')
  static double expoInOut(double t) {
    if (t == 0) {
      return 0;
    } else if (t == 1) {
      return 1;
    } else if ((t *= 2) < 1) {
      return 0.5 * math.exp(ln2_10 * (t - 1));
    } else {
      return 0.5 * (2 - math.exp(-ln2_10 * (t - 1)));
    }
  }

  @pragma('vm:prefer-inline')
  static double expoOutIn(double t) {
    if (t < 0.5) {
      return 0.5 * (1 - math.exp(-20 * ln2 * t));
    } else if (t == 0.5) {
      return 0.5;
    } else {
      return 0.5 * (math.exp(20 * ln2 * (t - 1)) + 1);
    }
  }

  /// === CIRCULAR ===
  // static double circIn(double t) => 1 - math.sqrt(1 - t * t);
  // public static inline function circIn(t:Float):Float {
  @pragma('vm:prefer-inline')
  static double circIn(double t) {
    if (t < -1 || 1 < t) {
      return 0;
    } else {
      return 1 - math.sqrt(1 - t * t);
    }
  }

  @pragma('vm:prefer-inline')
  static double circOut(double t) {
    if (t < 0 || 2 < t) {
      return 0;
    } else {
      return math.sqrt(t * (2 - t));
    }
  }

  @pragma('vm:prefer-inline')
  static double circInOut(double t) {
    if (t < -0.5 || 1.5 < t) {
      return 0.5;
    } else if ((t *= 2) < 1) {
      return -0.5 * (math.sqrt(1 - t * t) - 1);
    } else {
      return 0.5 * (math.sqrt(1 - (t -= 2) * t) + 1);
    }
  }

  @pragma('vm:prefer-inline')
  static double circOutIn(double t) {
    if (t < 0) {
      return 0;
    } else if (1 < t) {
      return 1;
    } else if (t < 0.5) {
      return 0.5 * math.sqrt(1 - (t = t * 2 - 1) * t);
    } else {
      return -0.5 * ((math.sqrt(1 - (t = t * 2 - 1) * t) - 1) - 1);
    }
  }

  /// === bounce ===
  @pragma('vm:prefer-inline')
  static double bounceIn(double t) {
    if ((t = 1 - t) < (1 / 2.75)) {
      return 1 - ((7.5625 * t * t));
    } else if (t < (2 / 2.75)) {
      return 1 - ((7.5625 * (t -= (1.5 / 2.75)) * t + 0.75));
    } else if (t < (2.5 / 2.75)) {
      return 1 - ((7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375));
    } else {
      return 1 - ((7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375));
    }
  }

  @pragma('vm:prefer-inline')
  static double bounceOut(double t) {
    const n1 = 7.5625;
    const d1 = 2.75;
    if (t < 1 / d1) {
      return n1 * t * t;
    } else if (t < 2 / d1) {
      return n1 * (t -= 1.5 / d1) * t + 0.75;
    } else if (t < 2.5 / d1) {
      return n1 * (t -= 2.25 / d1) * t + 0.9375;
    } else {
      return n1 * (t -= 2.625 / d1) * t + 0.984375;
    }
  }

  @pragma('vm:prefer-inline')
  static double bounceInOut(double t) {
    if (t < 0.5) {
      if ((t = (1 - t * 2)) < (1 / 2.75)) {
        return (1 - ((7.5625 * t * t))) * 0.5;
      } else if (t < (2 / 2.75)) {
        return (1 - ((7.5625 * (t -= (1.5 / 2.75)) * t + 0.75))) * 0.5;
      } else if (t < (2.5 / 2.75)) {
        return (1 - ((7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375))) * 0.5;
      } else {
        return (1 - ((7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375))) * 0.5;
      }
    } else {
      if ((t = (t * 2 - 1)) < (1 / 2.75)) {
        return ((7.5625 * t * t)) * 0.5 + 0.5;
      } else if (t < (2 / 2.75)) {
        return ((7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) * 0.5 + 0.5;
      } else if (t < (2.5 / 2.75)) {
        return ((7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) * 0.5 + 0.5;
      } else {
        return ((7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) * 0.5 + 0.5;
      }
    }
  }

  @pragma('vm:prefer-inline')
  static double bounceOutIn(double t) {
    if (t < 0.5) {
      if ((t = (t * 2)) < (1 / 2.75)) {
        return 0.5 * (7.5625 * t * t);
      } else if (t < (2 / 2.75)) {
        return 0.5 * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75);
      } else if (t < (2.5 / 2.75)) {
        return 0.5 * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375);
      } else {
        return 0.5 * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375);
      }
    } else {
      if ((t = (1 - (t * 2 - 1))) < (1 / 2.75)) {
        return 0.5 - (0.5 * (7.5625 * t * t)) + 0.5;
      } else if (t < (2 / 2.75)) {
        return 0.5 - (0.5 * (7.5625 * (t -= (1.5 / 2.75)) * t + 0.75)) + 0.5;
      } else if (t < (2.5 / 2.75)) {
        return 0.5 - (0.5 * (7.5625 * (t -= (2.25 / 2.75)) * t + 0.9375)) + 0.5;
      } else {
        return 0.5 -
            (0.5 * (7.5625 * (t -= (2.625 / 2.75)) * t + 0.984375)) +
            0.5;
      }
    }
  }

  /// === BACK easing ===

  static const double defaultOvershoot = 1.70158;

  @pragma('vm:prefer-inline')
  static double backIn(double t, [double c1 = EasingTools.defaultOvershoot]) {
    // if (t == 0) {
    //   return 0;
    // } else if (t == 1) {
    //   return 1;
    // } else {
    //   return t * t * ((overshoot + 1) * t - overshoot);
    // }
    final c3 = c1 + 1;
    return c3 * t * t * t - c1 * t * t;
  }

  @pragma('vm:prefer-inline')
  static double backOut(double t, [double c1 = EasingTools.defaultOvershoot]) {
    if (t == 0) {
      return 0;
    } else if (t == 1) {
      return 1;
    } else {
      return ((t = t - 1) * t * ((c1 + 1) * t + c1) + 1);
    }
  }

  @pragma('vm:prefer-inline')
  static double backInOut(double t,
      [double c1 = EasingTools.defaultOvershoot]) {
    if (t == 0) {
      return 0;
    } else if (t == 1) {
      return 1;
    } else if ((t *= 2) < 1) {
      return 0.5 * (t * t * (((c1 * 1.525) + 1) * t - c1 * 1.525));
    } else {
      return 0.5 * ((t -= 2) * t * (((c1 * 1.525) + 1) * t + c1 * 1.525) + 2);
    }
  }

  @pragma('vm:prefer-inline')
  static double backOutIn(double t,
      [double c1 = EasingTools.defaultOvershoot]) {
    if (t == 0) {
      return 0;
    } else if (t == 1) {
      return 1;
    } else if (t < 0.5) {
      return 0.5 * ((t = t * 2 - 1) * t * ((c1 + 1) * t + c1) + 1);
    } else {
      return 0.5 * (t = t * 2 - 1) * t * ((c1 + 1) * t - c1) + 0.5;
    }
  }

  /// === ELASTIC easing ===

  static const double defaultAmplitude = 1;
  static const double defaultPeriod = 0.0003;

  @pragma('vm:prefer-inline')
  static double elasticIn(
    double t, [
    double period = EasingTools.defaultPeriod,
    double amplitude = EasingTools.defaultAmplitude,
  ]) {
    if (t == 0) {
      return 0;
    } else if (t == 1) {
      return 1;
    } else {
      var s = period / 4;
      return -(amplitude *
          math.exp(ln2_10 * (t -= 1)) *
          math.sin((t * 0.001 - s) * (2 * pi) / period));
    }
  }

  @pragma('vm:prefer-inline')
  static double elasticOut(
    double t, [
    double period = EasingTools.defaultPeriod,
    double amplitude = EasingTools.defaultAmplitude,
  ]) {
    if (t == 0) {
      return 0;
    } else if (t == 1) {
      return 1;
    } else {
      var s = period / 4;
      return amplitude *
              math.exp(-ln2_10 * t) *
              math.sin((t * 0.001 - s) * (2 * pi) / period) +
          1;
    }
  }

  @pragma('vm:prefer-inline')
  static double elasticInOut(double t,
      [double period = EasingTools.defaultPeriod,
      double amplitude = EasingTools.defaultAmplitude]) {
    if (t == 0) {
      return 0;
    } else if (t == 1) {
      return 1;
    } else {
      var s = period / 4;
      if ((t *= 2) < 1) {
        return -0.5 *
            (amplitude *
                math.exp(ln2_10 * (t -= 1)) *
                math.sin((t * 0.001 - s) * pi2 / period));
      } else {
        return amplitude *
                math.exp(-ln2_10 * (t -= 1)) *
                math.sin((t * 0.001 - s) * pi2 / period) *
                0.5 +
            1;
      }
    }
  }

  @pragma('vm:prefer-inline')
  static double elasticOutIn(double t,
      [double period = EasingTools.defaultPeriod,
      double amplitude = EasingTools.defaultAmplitude]) {
    if (t < 0.5) {
      if ((t *= 2) == 0) {
        return 0;
      } else {
        var s = period / 4;
        return (amplitude / 2) *
                math.exp(-ln2_10 * t) *
                math.sin((t * 0.001 - s) * pi2 / period) +
            0.5;
      }
    } else {
      if (t == 0.5) {
        return 0.5;
      } else if (t == 1) {
        return 1;
      } else {
        t = t * 2 - 1;
        var s = period / 4;
        return -((amplitude / 2) *
                math.exp(ln2_10 * (t -= 1)) *
                math.sin((t * 0.001 - s) * pi2 / period)) +
            0.5;
      }
    }
  }

  @pragma('vm:prefer-inline')
  static double warpOut(double t) => t <= 0 ? 0 : 1;

  @pragma('vm:prefer-inline')
  static double warpIn(double t) => t < 1 ? 0 : 1;

  @pragma('vm:prefer-inline')
  static double warpInOut(double t) => t < .5 ? 0 : 1;

  @pragma('vm:prefer-inline')
  static double warpOutIn(double t) {
    if (t <= 0) {
      return 0;
    } else if (t < 1) {
      return .5;
    }
    return 1;
  }
}
