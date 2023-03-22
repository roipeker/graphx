part of gtween;

/// A [GTweenable] implementation for a [GDisplayObject].
///
class GTweenableDisplayObject with GTweenable {
  /// Creates a [GTweenableDisplayObject] instance for a [target] object.
  GTweenableDisplayObject(GDisplayObject target) {
    this.target = target;
    _addLerp(
      'colorize',
      GTweenLerpColor(
        setProp: (value) => target.colorize = value,
        getProp: () => target.colorize,
      ),
    );
  }

  /// Returns a [Map] of property accessors for the [target] object.
  @override
  Map<String, List<Function>> getTweenableAccessors() {
    return CommonTweenWraps.displayObject(target as GDisplayObject?);
  }

  /// Wraps a [target] object in a [GTweenableDisplayObject] instance.
  ///
  /// If the [target] is not a [GDisplayObject], it returns `null`.
  static GTweenable? wrap(Object? target) {
    if (target is! GDisplayObject) {
      return null;
    }
    return GTweenableDisplayObject(target);
  }
}
