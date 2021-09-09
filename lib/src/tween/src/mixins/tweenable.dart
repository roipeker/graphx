part of gtween;

typedef GTweenSetProp<T> = void Function(T targetValue);
typedef GTweenGetProp<T> = T Function();

class GTweenLerpProp<T> {
  T? from;
  T? to;
  String? name;

  GTweenSetProp<T>? setProp;
  GTweenGetProp<T>? getProp;

  GTweenLerpProp({this.setProp, this.getProp});

  T? resolve(double ratio) => null;
}

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
  late Object? target;

  /// override to know which properties will change.
  void setTweenProp(PropTween tweenProp) {
    final key = '${tweenProp.p}';
    if (!_lerps.containsKey(key)) return;
    final lerpObj = _lerps[key]!;
    lerpObj.to = tweenProp.cObj;
    tweenProp.c = 1.0;
  }

  final Map<String, GTweenLerpProp> _lerps = {};

  @override
  String toString() => '[GTweenable] $target';

  Map<Object, List<Function>>? _accessors;

  /// Lerps are special objects that are not `double` like
  /// Color, Rect, etc.
  void _addLerp(String prop, GTweenLerpProp lerp) {
    _lerps[prop] = lerp;
  }

  void initProps() => _accessors = getTweenableAccessors();

  /// implement in class.
  Map<String, List<Function>>? getTweenableAccessors() => null;

  void setProperty(Object prop, double value) {
    final key = '$prop';
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

  double getProperty(Object prop) {
    if (_lerps.containsKey(prop)) {
      _lerps[prop as String]?.from = _lerps[prop]?.getProp!();
      // TODO: add initLerp(prop) to read the initial value from `target` ?
      return 0.0;
    }
    if (_accessors == null) initProps();
    return _accessors![prop]![0]();
  }

  /// when tween is disposed.
  void dispose() {
    _lerps.clear();
    // _lerps = null;
  }

  double? operator [](String key) => getProperty(key);

  void operator []=(String key, double value) => setProperty(key, value);
}
