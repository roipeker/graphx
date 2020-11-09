part of gtween;

/// Base interface used by [GTween] to animate properties.
/// As Flutter has no reflection, we need this class to get/set properties
/// on target objects.
mixin GTweenable {
  /// actual target object where we should get the accessors from.
  /// If a "wrapper" is registered under the same Type as [target],
  /// [GTween] will use it internally to create a [GTweenable].
  /// Also used by [GTween] to reference internally the "_nativeTarget" instead
  /// of the [GTweenable] instance. So you can "kill" the tween by [GTweenable]
  /// or using the actual object that you plan to Tween.
  Object target;

  /// override to know which properties will change.
  void setTweenProp(PropTween tweenProp) {}

  @override
  String toString() => '[GTweenable] ' + target?.toString();

  Map<Object, List<Function>> _accessors;

  void initProps() => _accessors = getTweenableAccessors();

  /// implement in class.
  Map<String, List<Function>> getTweenableAccessors() => null;

  void setProperty(Object prop, double value) {
    if (_accessors == null) initProps();
    _accessors[prop][1](value);
  }

  double getProperty(Object prop) {
    if (_accessors == null) initProps();

    /// analyze property type.
    return _accessors[prop][0]();
  }

  /// when tween is disposed.
  void dispose() {}

  double operator [](String key) => getProperty(key);

  void operator []=(String key, double value) => setProperty(key, value);
}
