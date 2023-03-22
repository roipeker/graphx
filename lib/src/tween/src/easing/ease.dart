part of gtween;

/// A function type that defines an easing curve.
/// It takes a value between 0.0 and 1.0 and returns a transformed value based
/// on the specific easing curve defined.
typedef EaseDef = double Function(double e);

/// A function type that applies an easing curve to a value between 0.0 and 1.0.
/// It takes a value between 0.0 and 1.0 and returns a transformed value based
/// on the specific easing curve applied.
typedef EaseFunction = double Function(double e);

/// A collection of predefined easing functions that can be used with [GTween].
///
/// Each function represents a different easing curve, from smooth to bouncy,
/// and can be used to create animations with different visual effects. The
/// functions are defined as static members of the [GEase] class and can be
/// accessed directly. Uses internally Flutter's [Curves].
///
abstract class GEase {
  /// The default easing function, used when no other function is specified.
  static EaseFunction defaultEasing = decelerate;

  /// The default easing function from Flutter's [Curves] class, used when no
  /// other function is specified. An easing function that starts and ends
  /// slowly but speeds up in the middle. This is a good choice for animations
  /// that should feel natural and organic, with an acceleration in the middle
  /// of the animation.
  static EaseFunction ease = Curves.ease.transform;

  /// An easing function that starts quickly but slows down towards the end.
  /// This is a good choice for animations that should start with a burst of
  /// energy and then gradually slow down, such as animations of objects coming
  /// to rest or fading away.
  static EaseFunction easeOut = Curves.easeOut.transform;

  /// An easing function that starts slowly but speeds up towards the end. This
  /// is a good choice for animations that should build up momentum gradually,
  /// such as animations of objects accelerating or scaling up over time.
  static EaseFunction easeIn = Curves.easeIn.transform;

  /// An easing function that starts and ends slowly but speeds up in the
  /// middle, and also slows down towards the end.
  ///
  /// This is a good choice for animations that should have a smooth and natural
  /// feel throughout the entire animation, with a focus on both acceleration
  /// and deceleration.
  static EaseFunction easeInOut = Curves.easeInOut.transform;

  /// An elastic easing function that starts slowly and then accelerates, before
  /// overshooting the target and then oscillating back to the final value.
  ///
  /// This is a good choice for animations that should have a bouncy or springy
  /// feel, such as animations of objects bouncing or stretching.
  static EaseFunction elasticIn = Curves.elasticIn.transform;

  /// An elastic easing function that overshoots the target and then oscillates
  /// back to the final value, but with a faster deceleration than [elasticIn].
  ///
  /// This is a good choice for animations that should have a dramatic and
  /// energetic feel, such as animations of objects bouncing off walls or other
  /// obstacles.
  static EaseFunction elasticOut = Curves.elasticOut.transform;

  /// An elastic easing function that combines the properties of [elasticIn] and
  /// [elasticOut], starting with a slow acceleration, overshooting the target,
  /// and then oscillating back to the final value with a faster deceleration.
  ///
  /// This is a good choice for animations that should have a bouncy or springy
  /// feel throughout the entire animation, with a focus on both acceleration
  /// and deceleration.
  static EaseFunction elasticInOut = Curves.elasticInOut.transform;

  /// A bouncing easing function that starts quickly and then bounces back and
  /// forth towards the final value before coming to rest.
  ///
  /// This is a good choice for animations that should have a playful or
  /// whimsical feel, such as animations of buttons or other interactive
  /// elements.
  static EaseFunction bounceOut = Curves.bounceOut.transform;

  /// A bouncing easing function that starts with a small bounce before
  /// gradually increasing the amplitude of the bounces, before coming to rest.
  ///
  /// This is a good choice for animations that should have a more subdued and
  /// controlled bounce than [bounceOut], such as animations of progress bars or
  /// loading indicators.
  static EaseFunction bounceIn = Curves.bounceIn.transform;

  /// A bouncing easing function that combines the properties of [bounceIn] and
  /// [bounceOut], starting with a small bounce, gradually increasing the
  /// amplitude of the bounces, and then coming to rest.
  ///
  /// This is a good choice for animations that should have a playful or
  /// whimsical feel throughout the entire animation, with a focus on both
  /// acceleration and deceleration.
  static EaseFunction bounceInOut = Curves.bounceInOut.transform;

  /// An easing function that starts with a slight overshoot before returning to
  /// the final value, with a faster deceleration than [easeInBack].
  ///
  /// This is a good choice for animations that should have a natural and
  /// organic feel, such as animations of objects moving in and out of view.
  static EaseFunction easeOutBack = Curves.easeOutBack.transform;

  /// An easing function that starts with a slight overshoot before returning to
  /// the final value, with a slower acceleration than easeOutBack.
  ///
  /// This is a good choice for animations that should have a smooth and gradual
  /// buildup of momentum, such as animations of objects appearing or scaling
  /// up.
  static EaseFunction easeInBack = Curves.easeInBack.transform;

  /// An easing function that combines the properties of easeInBack and
  /// [easeOutBack], starting with a slight overshoot, building up momentum
  /// gradually, and then returning to the final value with a faster
  /// deceleration than [easeInBack].
  ///
  /// This is a good choice for animations that should have a natural and
  /// organic feel throughout the entire animation, with a focus on both
  /// acceleration and deceleration.
  static EaseFunction easeInOutBack = Curves.easeInOutBack.transform;

  /// An easing function that starts with a quick acceleration and then
  /// decelerates towards the final value with a sinusoidal curve.
  ///
  /// This is a good choice for animations that should have a smooth and gentle
  /// acceleration and deceleration, such as animations of transitions or fades.
  static EaseFunction easeOutSine = Curves.easeOutSine.transform;

  /// An easing function that starts with a slow acceleration and then
  /// accelerates towards the final value with a sinusoidal curve.
  ///
  /// This is a good choice for animations that should have a gradual buildup of
  /// momentum, such as animations of objects moving across the screen or
  /// scaling up.
  static EaseFunction easeInSine = Curves.easeInSine.transform;

  /// An easing function that combines the properties of [easeInSine] and
  /// [easeOutSine], starting with a slow acceleration, building up momentum
  /// with a sinusoidal curve, and then decelerating towards the final value
  /// with a sinusoidal curve.
  ///
  /// This is a good choice for animations that should have a smooth and natural
  /// feel throughout the entire animation, with a focus on both acceleration
  /// and deceleration.
  static EaseFunction easeInOutSine = Curves.easeInOutSine.transform;

  /// An easing function that starts with a quick acceleration and then
  /// decelerates towards the final value with a quadratic curve.
  ///
  /// This is a good choice for animations that should have a fast and energetic
  /// start with a gradual slowdown towards the end, such as animations of UI
  /// elements sliding or popping into view.
  static EaseFunction easeOutQuad = Curves.easeOutQuad.transform;

  /// An easing function that starts with a slow acceleration and then
  /// accelerates towards the final value with a quadratic curve.
  ///
  /// This is a good choice for animations that should have a gradual buildup of
  /// momentum with a smooth and natural feel, such as animations of objects
  /// scaling up or down.
  static EaseFunction easeInQuad = Curves.easeInQuad.transform;

  /// An easing function that combines the properties of [easeInQuad] and
  /// [easeOutQuad], starting with a slow acceleration, building up momentum
  /// with a quadratic curve, and then decelerating towards the final value with
  /// a quadratic curve.
  ///
  /// This is a good choice for animations that should have a smooth and natural
  /// feel throughout the entire animation, with a focus on both acceleration
  /// and deceleration.
  static EaseFunction easeInOutQuad = Curves.easeInOutQuad.transform;

  /// An easing function that starts with a quick acceleration and then
  /// decelerates towards the final value with a cubic curve.
  ///
  /// This is a good choice for animations that should have a fast and energetic
  /// start with a gradual slowdown towards the end, such as animations of UI
  /// elements sliding or popping into view.
  static EaseFunction easeOutCubic = Curves.easeOutCubic.transform;

  /// An easing function that starts with a slow acceleration and then
  /// accelerates towards the final value with a cubic curve.
  ///
  /// This is a good choice for animations that should have a gradual buildup of
  /// momentum with a smooth and natural feel, such as animations of objects
  /// scaling up or down.
  static EaseFunction easeInCubic = Curves.easeInCubic.transform;

  /// An easing function that combines the properties of [easeInCubic] and
  /// [easeOutCubic], starting with a slow acceleration, building up momentum
  /// with a cubic curve, and then decelerating towards the final value with a
  /// cubic curve.
  ///
  /// This is a good choice for animations that should have a smooth and natural
  /// feel throughout the entire animation, with a focus on both acceleration
  /// and deceleration.
  static EaseFunction easeInOutCubic = Curves.easeInOutCubic.transform;

  /// An easing function that starts with a quick acceleration and then
  /// decelerates towards the final value with a quartic curve.
  ///
  /// This is a good choice for animations that should have a fast and energetic
  /// start with a gradual slowdown towards the end, such as animations of UI
  /// elements sliding or popping into view.
  static EaseFunction easeOutQuart = Curves.easeOutQuart.transform;

  /// An easing function that starts with a slow acceleration and then
  /// accelerates towards the final value with a quartic curve.
  ///
  /// This is a good choice for animations that should have a gradual buildup of
  /// momentum with a smooth and natural feel, such as animations of objects
  /// scaling up or down.
  static EaseFunction easeInQuart = Curves.easeInQuart.transform;

  /// An easing function that combines the properties of [easeInQuart] and
  /// [easeOutQuart], starting with a slow acceleration, building up momentum
  /// with a quartic curve, and then decelerating towards the final value with a
  /// quartic curve.
  ///
  /// This is a good choice for animations that should have a smooth and natural
  /// feel throughout the entire animation, with a focus on both acceleration
  /// and deceleration.
  static EaseFunction easeInOutQuart = Curves.easeInOutQuart.transform;

  /// An easing function that starts with a quick acceleration and then
  /// decelerates towards the final value with a quintic curve.
  ///
  /// This is a good choice for animations that should have a fast and energetic
  /// start with a gradual slowdown towards the end, such as animations of UI
  /// elements sliding or popping into view.
  static EaseFunction easeOutQuint = Curves.easeOutQuint.transform;

  /// An easing function that starts with a slow acceleration and then
  /// accelerates towards the final value with a quintic curve.
  ///
  /// This is a good choice for animations that should have a gradual buildup of
  /// momentum with a smooth and natural feel, such as animations of objects
  /// scaling up or down.
  static EaseFunction easeInQuint = Curves.easeInQuint.transform;

  /// An easing function that combines the properties of [easeInQuint] and
  /// [easeOutQuint], starting with a slow acceleration, building up momentum
  /// with a quintic curve, and then decelerating towards the final value with a
  /// quintic curve.
  ///
  /// This is a good choice for animations that should have a smooth and natural
  /// feel throughout the entire animation, with a focus on both acceleration
  /// and deceleration.
  static EaseFunction easeInOutQuint = Curves.easeInOutQuint.transform;

  /// [EaseFunction] with an output curve that starts quickly and slows down
  /// towards the end. It's useful for simulating a circular motion or a motion
  /// that starts and ends quickly.
  static EaseFunction easeOutCirc = Curves.easeOutCirc.transform;

  /// [EaseFunction] with an input curve that starts slowly and speeds up
  /// towards the end. It's useful for simulating an object that gradually gains
  /// speed, like a pendulum swing.
  static EaseFunction easeInCirc = Curves.easeInCirc.transform;

  /// The [EaseFunction] with an input curve that starts slowly, speeds up in
  /// the middle, and slows down towards the end. It's useful for simulating a
  /// motion that gradually speeds up, reaches its maximum velocity in the
  /// middle, and then slows down again.
  static EaseFunction easeInOutCirc = Curves.easeInOutCirc.transform;

  /// The [EaseFunction] with an output curve that starts quickly and slows down
  /// towards the end, but in a more exaggerated way than [easeOutCirc]. It's
  /// useful for simulating a motion that needs to appear more dramatic, like an
  /// object that is accelerating faster than normal.
  static EaseFunction easeOutExpo = Curves.easeOutCirc.transform;

  /// The [EaseFunction] with an input curve that starts slowly and speeds up
  /// towards the end. It's useful for simulating an object that gradually gains
  /// speed, but in a more exaggerated way than
  static EaseFunction easeInExpo = Curves.easeInExpo.transform;

  /// The [EaseFunction] with an input curve that starts slowly, speeds up in
  /// the middle, and slows down towards the end, but in a more exaggerated way
  /// than [easeInOutCirc]. It's useful for simulating a motion that gradually
  /// speeds up, reaches its maximum velocity in the middle, and then slows down
  /// again, but with a more dramatic effect.
  static EaseFunction easeInOutExpo = Curves.easeInOutExpo.transform;

  /// An easing function that starts with a fast acceleration and then
  /// decelerates towards the final value with a sine curve.
  ///
  /// This is a good choice for animations that should have a quick start with a
  /// smooth and natural deceleration, such as animations of UI elements sliding
  /// or popping into view.
  static EaseFunction decelerate = Curves.decelerate.transform;

  /// An easing function that starts with a slow acceleration and then
  /// accelerates towards the final value with a linear curve.
  ///
  /// This is a good choice for animations that should have a gradual buildup of
  /// momentum with a natural feel, such as animations of objects scaling up or
  /// down.
  static EaseFunction easeInToLinear = Curves.easeInToLinear.transform;

  /// An easing function that starts with a fast acceleration and then
  /// decelerates towards the final value with an ease-in curve.
  ///
  /// This is a good choice for animations that should have a quick start with a
  /// smooth and natural deceleration, such as animations of UI elements sliding
  /// or popping into view.
  static EaseFunction fastLinearToSlowEaseIn =
      Curves.fastLinearToSlowEaseIn.transform;

  /// An easing function that starts with a quick acceleration, slows down in
  /// the middle, and then accelerates again towards the final value with an
  /// ease-in curve.
  ///
  /// This is a good choice for animations that should have a quick start with a
  /// smooth deceleration, a slower middle section, and a fast finish, such as
  /// animations of UI elements transitioning between screens.
  static EaseFunction fastOutSlowIn = Curves.fastOutSlowIn.transform;

  /// An easing function that applies a linear rate of change, resulting in a
  /// constant speed throughout the entire animation.
  ///
  /// This is a good choice for animations that should have a consistent and
  /// predictable speed, such as animations of objects moving along a path.
  static EaseFunction linear = Curves.linear.transform;

  /// An easing function that starts with a linear rate of change and then
  /// decelerates towards the final value with an ease-out curve.
  ///
  /// This is a good choice for animations that should start at a consistent
  /// speed and then gradually slow down towards the end, such as animations of
  /// UI elements fading out or moving off screen.
  static EaseFunction linearToEaseOut = Curves.linearToEaseOut.transform;

  /// An easing function that starts with a slow acceleration, builds up
  /// momentum in the middle with a linear curve, and then decelerates towards
  /// the final value with an ease-out curve.
  ///
  /// This is a good choice for animations that should have a gradual buildup of
  /// speed in the middle of the animation with a smooth deceleration towards
  /// the end, such as animations of UI elements transitioning between screens.
  static EaseFunction slowMiddle = Curves.slowMiddle.transform;
}
