part of gtween;

/// A set of extension methods on the [Color] class for creating GTween
/// animations.
///
/// These extensions add a twn getter property to [Color] instances, which
/// returns a [GTweenableColor] object that can be used to create GTween
/// animations.
extension GTweenColorExt on Color {

  /// Returns a [GTweenableColor] instance that can be used to animate the
  /// properties of this point with a [GTween] animation.
  GTweenableColor get twn {
    return GTweenableColor(this);
  }
}

/// A set of extension methods on the [GPoint] class for creating GTween
/// animations.
///
/// These extensions add a twn getter property to [GPoint] instances, which
/// returns a [GTweenablePoint] object that can be used to create GTween
/// animations.
extension GTweenPointExt on GPoint {

  /// Returns a [GTweenablePoint] instance that can be used to animate the
  /// properties of this point with a [GTween] animation.
  GTweenablePoint get twn {
    return GTweenablePoint(this);
  }
}

/// A set of extension methods on the [GRect] class for creating GTween
/// animations.
///
/// These extensions add a twn getter property to [GRect] instances, which
/// returns a [GTweenableRect] object that can be used to create GTween
/// animations.
extension GTweenRectExt on GRect {

  /// Returns a [GTweenableRect] object that wraps this [GRect] instance,
  /// allowing it to be used with GTween animations. Use this to animate
  /// the properties of the rectangle, such as its position, size, and anchor
  /// point. For example:
  ///
  /// ```dart
  /// final myRect = GRect(0, 0, 100, 100);
  /// myRect.twn.tween(
  ///   duration: 1.0,
  ///   x: 200,
  ///   y: 200,
  ///   width: 50,
  ///   height: 50,
  ///   pivotX: 0.5,
  ///   pivotY: 0.5,
  ///   ease: GEase.elasticOut,
  ///   onComplete: () => print('Animation completed!'),
  /// );
  /// ```
  ///
  /// This will animate the rectangle from its initial position and size to a
  /// new position of (200, 200), a size of (50, 50), and a pivot point located
  /// at its center. The animation will use an elastic-out easing function and
  /// will print a message to the console when it completes.
  GTweenableRect get twn {
    return GTweenableRect(this);
  }
}
