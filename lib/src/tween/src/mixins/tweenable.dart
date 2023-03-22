part of gtween;

/// Getter function for [GTweenLerpProp]. It returns a value of type T
/// which represents the current value of the property.
typedef GTweenGetProp<T> = T Function();

/// Setter function for [GTweenLerpProp]. It takes a single argument
/// of type T which represents the value to set for the property.
typedef GTweenSetProp<T> = void Function(T targetValue);

/// Base interface used by [GTween] to animate properties.
/// As Flutter has no reflection, we need this class to get/set properties
/// on target objects.
mixin GTweenable {
  /// The actual target object where we should get the accessors from. If a
  /// "wrapper" is registered under the same Type as [target], [GTween] will use
  /// it internally to create a [GTweenable]. Also used by [GTween] to reference
  /// internally the "_nativeTarget" instead of the [GTweenable] instance. So
  /// you can "kill" the tween by [GTweenable] or using the actual object that
  /// you plan to Tween.
  late Object? target;

  /// Map that stores the [GTweenLerpProp] objects for each tweenable property.
  final Map<String, GTweenLerpProp> _lerps = {};

  /// Map of accessors that allow [GTween] to 'get' and 'set' properties. The
  /// key of the map is the property name and the value is a list of functions.
  /// The first function is used to get the property value from the target
  /// object, and the second function is used to set the property value on the
  /// target object.
  Map<Object, List<Function>>? _accessors;

  /// Overridden operator that allows to "get" the property value of a specific
  /// key without calling the [getProperty] method.
  ///
  /// Returns the value of the given [key] or null if the key is not found.
  double? operator [](String key) {
    return getProperty(key);
  }

  /// Overridden operator that allows to "set" the property value of a specific
  /// key without calling the [setProperty] method.
  ///
  /// Sets the value of the given [key] to the given [value].
  void operator []=(String key, double value) {
    setProperty(key, value);
  }

  /// Called when the tween is disposed.
  void dispose() {
    _lerps.clear();
  }

  /// Gets the value of the property [prop].
  double getProperty(Object prop) {
    if (_lerps.containsKey(prop)) {
      _lerps[prop as String]?.from = _lerps[prop]?.getProp!();
      // TODO: add initLerp(prop) to read the initial value from `target` ?
      return 0.0;
    }
    if (_accessors == null) {
      initProps();
    }
    return _accessors![prop]![0]();
  }

  /// (Internal)
  /// Implemented in sub classes.
  Map<String, List<Function>>? getTweenableAccessors() {
    return null;
  }

  /// This method initializes the [_accessors] map with the object's properties
  /// and their corresponding getter and setter functions. The
  /// [getTweenableAccessors] method should be implemented in the target object
  /// class and should return a map of property names and their corresponding
  /// getter and setter functions. If no such map is returned, the _accessors
  /// map remains null.
  void initProps() {
    _accessors = getTweenableAccessors();
  }

  /// Sets the value of the property [property] to [value].
  void setProperty(Object property, double value) {
    final key = '$property';
    if (_lerps.containsKey(key)) {
      _lerps[key]?.resolve(value);
    } else {
      if (_accessors == null) initProps();
      _accessors![key]![1](value);
    }
    // if (_lerps[prop as String] != null) {
    //   _lerps[prop]!.resolve(value);
    //   // TODO: add setLerp(prop, value) function to be override?
    // } else {
    //   if (_accessors == null) initProps();
    //   _accessors![prop]![1](value);
    // }
  }

  /// (Internal usage)
  ///
  /// Overrides to know which properties will change.
  /// Sets the tween property for a [PropTween].
  ///
  /// This method sets the "to" value for the corresponding GTweenLerpProp
  /// object in the [_lerps] map using the key from the given [tweenProp].
  ///
  /// If the key does not exist in [_lerps], the method returns without
  /// making any changes.
  ///
  /// The "to" value of the GTweenLerpProp object is set to the "cObj" value
  /// of the given [tweenProp], and the "c" value of [tweenProp] is set to 1.0.
  void setTweenProp(PropTween tweenProp) {
    final key = '${tweenProp.p}';
    if (!_lerps.containsKey(key)) {
      return;
    }
    final lerpObj = _lerps[key]!;
    lerpObj.to = tweenProp.cObj;
    tweenProp.c = 1.0;
  }

  /// Returns a string representation of this [GTweenable] object.
  ///
  /// The returned string includes the type and the target object of this
  /// [GTweenable] instance.
  @override
  String toString() {
    return '[GTweenable] $target';
  }

  /// "Lerps" are special objects that are not `double` like
  /// `Color`, `GRect`, etc.
  void _addLerp(String property, GTweenLerpProp lerp) {
    _lerps[property] = lerp;
  }
}

/// Base class representing a property to be animated by [GTween].
class GTweenLerpProp<T> {
  /// The starting value of the property to be tweened.
  T? from;

  /// The target value of the property to be tweened.
  T? to;

  /// The name of the property to be tweened.
  String? name;

  /// Setter function to apply the tweened value to the target object.
  GTweenSetProp<T>? setProp;

  /// Getter function to retrieve the current value of the property.
  GTweenGetProp<T>? getProp;

  /// Constructor for a GTweenLerpProp instance.
  GTweenLerpProp({this.setProp, this.getProp});

  /// Given a ratio between 0 and 1, calculates the interpolated value of the
  /// property being animated and returns it.
  T? resolve(double ratio) {
    return null;
  }
}
