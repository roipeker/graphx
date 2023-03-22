part of gtween;

/// (Internal usage)
///
/// Represents a property tween, which animates a single property of a target
/// object over time.
///
/// This class is used internally by GTween, and should not be instantiated
/// directly
///
class PropTween {
  /// The target or dynamic [GTweenable] object of this property tween.
  GTweenable? t;

  /// The property "name" (commonly a [String]), or value of this property tween.
  Object? p;

  /// The start value of this property tween.
  double s = 0.0;

  /// The amount to change, the difference between the end and start values.
  double? c;

  /// The original target object of this property tween.
  Object? cObj;

  /// Indicates if this property tween instance is a function.
  bool? f;

  /// The priority in the render queue.
  int? pr;

  /// Indicates if the target of this property tween is a tween plugin.
  bool? pg;

  /// The name of the original target property. Typically same as `t`.
  String? n;

  /// Indicates if this property tween should be rounded.
  bool? r;

  /// The next property tween in the linked list.
  PropTween? _next;

  /// The previous property tween in the linked list.
  PropTween? _prev;

  /// Creates a new instance of [PropTween].
  ///
  /// This constructor is used internally by [GTween], and should not be used
  /// directly.
  ///
  /// [target] The target object to animate.
  ///
  /// [property] The property to animate (commonly a String) or the value to
  /// interpolate.
  ///
  /// [start] The starting value of the property.
  ///
  /// [change] The difference between the end value and the start value.
  ///
  /// [name] The name of the original target property. Typically the same as
  /// `t`.
  ///
  /// [next] A reference to the next [PropTween] in the linked list.
  ///
  /// [priority] The priority in the render queue.
  PropTween({
    GTweenable? target,
    Object? property,
    double start = 0.0,
    double? change,
    String? name,
    PropTween? next,
    int priority = 0,
  }) {
    t = target;
    p = property;
    s = start;
    c = change;
    n = name;
//    this.f = this.t[p] is Function;
    if (next != null) {
      next._prev = this;
      _next = next;
    }
    pr = priority;
  }
}
