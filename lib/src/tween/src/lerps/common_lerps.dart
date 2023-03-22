part of gtween;

/// A [GTweenLerpProp] subclass that implements a linear interpolation function
/// for [Color] objects.
class GTweenLerpColor extends GTweenLerpProp<Color?> {
  /// Create a new instance of [GTweenLerpColor].
  ///
  /// The [setProp] and [getProp] parameters are inherited from
  /// [GTweenLerpProp].
  GTweenLerpColor({
    super.setProp,
    super.getProp,
  });

  // Calculates the [Color] value at the given ratio using [Color.lerp], and
  // calls [setProp] to set the resolved value to the target object.
  ///
  /// Returns the resolved [Color] value.
  @override
  Color? resolve(double ratio) {
    final value = Color.lerp(from, to, ratio);
    setProp?.call(value);
    return value;
  }
}
