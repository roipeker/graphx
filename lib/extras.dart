///
/// roipeker, 2022
///
///
/// `Lerper` is  a collection of useful functions to make your own
/// tweens based on time/ratio/fraction.
///
/// Almost all methods are exposed as extension methods on `double`. So
/// you basically modify 1 number into a target value, making super simple
/// to chain transformations.
///
/// It also contains a basic [CurvePath] class to define a path of segments
/// of different types (linear, quadratic, cubic) and to get the value
/// at a given ratio (0-1). This can be used to create a motion path or
/// as a complex easing function to interpolate a single value over time.
///
/// Example:
///
///  ```dart
///  // counter as a frame counter...
///  var frames = 0;
///  void onTick(){
///    // ratio of 120 ticks (2 seconds if 60fps).
///    // [wrapLerp()] is a method that will return a value between 0 and 1,
///    // looping the value every 120 frames.
///    // It also takes a "start" value, that will work as a "delay" to
///    // the wrap interpolation, clamping `t` to 0.
///    var t = ++frames.wrapLerp(120)
///    // `x` will interpolate during 120 frames between 10 and 400 using
///    // sineOut curve.
///    var x = t.sineOut().lerp(10, 400);
///    // draw something with `x`
///  }
///  ```
///
/// ====

library extras;

export 'extras/lerper/lerper.dart';
export 'extras/segment.dart';
