import 'package:graphx/graphx/tween/tween_interp.dart';
import 'package:graphx/graphx/tween/tween_step.dart';

class FloatInterp implements TweenInterp {
  TweenStep _tween;

  double duration;
  double to;
  double from;
  bool relative = false;
  double $time;

  double difference;
  double current;
  TweenEase ease;
  bool complete;

  String property;
  String propertyGetter;
  String propertySetter;
  bool hasInitialized;

  double getFinalValue() => from + difference;

  FloatInterp(TweenStep tween) {
    _tween = tween;
    current = from = _getTargetValue();
  }

  void _init() {
    /// use getter-setter.
    current = from = _getTargetValue();
    difference = relative ? to : to - from;
    hasInitialized = true;
  }

  double _getTargetValue() {
    /// WTF TO DO.
    var a = _tween.getTarget();
    return 0;
  }

  void _setTargetValue(double value) {
    current = value;
//    var a = _tween.getTarget();
//    return 0;
  }

  void reset() {
    $time = 0;
    hasInitialized = false;
  }

  void update(double delta) {
    if (!hasInitialized) _init();
    $time += delta;
    double c;
    if ($time > duration) {
      $time = duration;
      c = from + difference;
      complete = true;
    } else {
      c = from + ease($time / duration) * difference;
    }
    setValue(c);
  }

  void setValue(double value) {
    if (value != current) _setTargetValue(value);
  }
}
