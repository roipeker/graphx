import 'dart:math';

typedef TransitionFunc = double Function(double);

abstract class Transitions {
  static List<TransitionFunc> values = [
    linear,
    easeIn,
    easeOut,
    easeInOut,
    easeOutIn,
    easeInBack,
    easeOutBack,
    easeInElastic,
    easeOutElastic
  ];

//  static Transitions instance = Transitions();

  /// --- functions ---
  static double linear(double ratio) => ratio;

  static double easeIn(double ratio) => ratio * ratio * ratio;

  static double easeOut(double ratio) {
    double invRatio = ratio - 1.0;
    return invRatio * invRatio * invRatio + 1;
  }

  static double easeInOut(double ratio) {
    return easeCombined(easeIn, easeOut, ratio);
  }

  static double easeOutIn(double ratio) {
    return easeCombined(easeOut, easeIn, ratio);
  }

  static const double pi2 = pi * 2;

  static const double _backF = 1.70158;
  static double easeInBack(double ratio) {
    return pow(ratio, 2) * ((_backF + 1.0) * ratio - _backF);
  }

  static double easeOutBack(double ratio) {
    var invRatio = ratio - 1.0;
    return pow(invRatio, 2) * ((_backF + 1.0) * invRatio + _backF) + 1.0;
  }

  static double easeInOutBack(double ratio) {
    return easeCombined(easeInBack, easeOutBack, ratio);
  }

  static double easeOutInBack(double ratio) {
    return easeCombined(easeOutBack, easeInBack, ratio);
  }

  static double easeInElastic(double ratio) {
    if (ratio == 0 || ratio == 1) return ratio;
    double p = .3, s = p / 4.0, invRatio = ratio - 1;
    return -1 * pow(2, 10 * invRatio) * sin((invRatio - s) * pi2 / p);
  }

  static double easeOutElastic(double ratio) {
    if (ratio == 0 || ratio == 1) return ratio;
    double p = .3, s = p / 4.0;
    return pow(2, -10 * ratio) * sin((ratio - s) * pi2 / p) + 1;
  }

  static double easeInOutElastic(double ratio) {
    return easeCombined(easeInElastic, easeOutElastic, ratio);
  }

  static double easeOutInElastic(double ratio) {
    return easeCombined(easeOutElastic, easeInElastic, ratio);
  }

//  static double easeInBounce(double ratio) {
//    return 1 - easeOutBounce(1 - ratio);
//  }
//
//  static double easeOutBounce(double ratio) {
//    const double s = 7.5625;
//    const double p = 2.75;
//    double ratio2 = pow(ratio, 2);
//    double l;
//    if (ratio < (1.0 / p)) {
//      l = s * ratio2;
//    } else {
//      if (ratio < (2.0 / p)) {
//        ratio -= 1.5 / p;
//        l = s * ratio2 + 0.75;
//      } else {
//        if (ratio < 2.5 / p) {
//          ratio -= 2.25 / p;
//          l = s * ratio2 + 0.9375;
//        } else {
//          ratio -= 2.625 / p;
//          l = s * ratio2 + 0.984375;
//        }
//      }
//    }
//    return l;
//  }
//
//  static double easeInOutBounce(double ratio) {
//    return easeCombined(easeInBounce, easeOutBounce, ratio);
//  }
//
//  static double easeOutInBounce(double ratio) {
//    return easeCombined(easeOutBounce, easeInBounce, ratio);
//  }

  static double easeCombined(
    TransitionFunc startFunc,
    TransitionFunc endFunc,
    double ratio,
  ) {
    return ratio < .5
        ? .5 * startFunc(ratio * 2.0)
        : .5 * endFunc((ratio - .5) * 2.0) + .5;
  }
}
