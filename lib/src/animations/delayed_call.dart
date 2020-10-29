import 'dart:math';

import '../../graphx.dart';
import 'updatable.dart';

class GxDelayedCall with IUpdatable, JugglerSignalMixin {
  Function target;
  double duration;
  double _currentTime;
  double _totalTime;
  int repeatCount;
  JugglerObjectEventData _eventData;

  double get currentTime => _currentTime;
  double get totalTime => _totalTime;
  bool get isComplete => repeatCount == 1 && _currentTime >= _totalTime;

  GxDelayedCall(Function callback, double delay) {
    _eventData = JugglerObjectEventData(this);
    reset(callback, delay);
  }

  @override
  void update(double delta) {
    var prevTime = _currentTime;
    _currentTime += delta;
    if (_currentTime > _totalTime) {
      _currentTime = _totalTime;
    }
    if (prevTime < _totalTime && _currentTime >= _totalTime) {
      if (repeatCount == 0 || repeatCount > 1) {
        target?.call();
        if (repeatCount > 0) repeatCount -= 1;
        _currentTime = 0;
        update((prevTime + delta) - _totalTime);
      } else {
        // save objects cause they might be changed from event.
        var $callback = target;

        /// during callback, people might wanna call [reset] and readd this to the
        /// juggler, so the signal has to be dispatched *before* executing the
        /// callback.
        $onRemovedFromJuggler?.dispatch(_eventData);
        $callback?.call();
      }
    }
  }

  void complete() {
    double restTime = _totalTime - _currentTime;
    if (restTime > 0) update(restTime);
  }

  GxDelayedCall reset(Function callback, double delay) {
    _currentTime = 0;
    target = callback;
    duration = delay;
    repeatCount = 1;
    _totalTime = max(duration, .0001);
    return this;
  }

  static List<GxDelayedCall> _pool = [];
  static void toPool(GxDelayedCall obj) {
    /// reset all references to make sure is garbage collected.
    obj.target = null;
    obj.$onRemovedFromJuggler?.removeAll();
    _pool.add(obj);
  }

  static GxDelayedCall fromPool(Function callback, double delay) {
    if (_pool.isNotEmpty) return _pool.removeLast().reset(callback, delay);
    return GxDelayedCall(callback, delay);
  }
}
