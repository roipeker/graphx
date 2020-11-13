part of gtween;

typedef EaseDef = double Function(double e);
typedef EaseFunction = double Function(double e);

abstract class GEase {
  static EaseFunction defaultEasing = decelerate;

  static EaseFunction ease = Curves.ease.transform;
  static EaseFunction easeOut = Curves.easeOut.transform;
  static EaseFunction easeIn = Curves.easeIn.transform;
  static EaseFunction easeInOut = Curves.easeInOut.transform;

  static EaseFunction elasticIn = Curves.elasticIn.transform;
  static EaseFunction elasticOut = Curves.elasticOut.transform;
  static EaseFunction elasticInOut = Curves.elasticInOut.transform;

  static EaseFunction bounceOut = Curves.bounceOut.transform;
  static EaseFunction bounceIn = Curves.bounceIn.transform;
  static EaseFunction bounceInOut = Curves.bounceInOut.transform;

  static EaseFunction easeOutBack = Curves.easeOutBack.transform;
  static EaseFunction easeInBack = Curves.easeInBack.transform;
  static EaseFunction easeInOutBack = Curves.easeInOutBack.transform;

  static EaseFunction easeOutSine = Curves.easeOutSine.transform;
  static EaseFunction easeInSine = Curves.easeInSine.transform;
  static EaseFunction easeInOutSine = Curves.easeInOutSine.transform;

  static EaseFunction easeOutQuad = Curves.easeOutQuad.transform;
  static EaseFunction easeInQuad = Curves.easeInQuad.transform;
  static EaseFunction easeInOutQuad = Curves.easeInOutQuad.transform;

  static EaseFunction easeOutCubic = Curves.easeOutCubic.transform;
  static EaseFunction easeInCubic = Curves.easeInCubic.transform;
  static EaseFunction easeInOutCubic = Curves.easeInOutCubic.transform;

  static EaseFunction easeOutQuart = Curves.easeOutQuart.transform;
  static EaseFunction easeInQuart = Curves.easeInQuart.transform;
  static EaseFunction easeInOutQuart = Curves.easeInOutQuart.transform;

  static EaseFunction easeOutQuint = Curves.easeOutQuint.transform;
  static EaseFunction easeInQuint = Curves.easeInQuint.transform;
  static EaseFunction easeInOutQuint = Curves.easeInOutQuint.transform;

  static EaseFunction easeOutCirc = Curves.easeOutCirc.transform;
  static EaseFunction easeInCirc = Curves.easeInCirc.transform;
  static EaseFunction easeInOutCirc = Curves.easeInOutCirc.transform;

  static EaseFunction easeOutExpo = Curves.easeOutCirc.transform;
  static EaseFunction easeInExpo = Curves.easeInExpo.transform;
  static EaseFunction easeInOutExpo = Curves.easeInOutExpo.transform;

  static EaseFunction decelerate = Curves.decelerate.transform;
  static EaseFunction easeInToLinear = Curves.easeInToLinear.transform;
  static EaseFunction fastLinearToSlowEaseIn =
      Curves.fastLinearToSlowEaseIn.transform;
  static EaseFunction fastOutSlowIn = Curves.fastOutSlowIn.transform;
  static EaseFunction linear = Curves.linear.transform;
  static EaseFunction linearToEaseOut = Curves.linearToEaseOut.transform;
  static EaseFunction slowMiddle = Curves.slowMiddle.transform;
}
