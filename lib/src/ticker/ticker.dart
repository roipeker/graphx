import 'package:flutter/scheduler.dart';

import '../events/events.dart';

class GTicker {
  GTicker();

  Ticker? _ticker;
  final onFrame = EventSignal<double>();

  VoidCallback? _nextFrameCallback;

  // ignore: use_setters_to_change_properties
  void callNextFrame(VoidCallback callback) {
    _nextFrameCallback = callback;
  }

  void _createTicker() {
    if (_ticker != null) return;
    _ticker = Ticker(_onTick);
    _ticker!.start();
    _ticker!.muted = true;
  }

  bool get isTicking => _ticker?.isTicking ?? false;

  // Whether time is elapsing for this [Ticker]. Becomes true when [start] is
  // called and false when [stop] is called.
  bool get isActive => _ticker?.isActive ?? false;

  double get currentTime => _currentTime;

  double get currentDeltaTime => _currentDeltaTime;

  double get currentDeltaRatio => _currentDeltaRatio;

  // Resumes the execution of this [Ticker]. This is equivalent to calling
  // [Ticker::muted] with `false`.
  void resume() {
    if (isTicking) return;
    _createTicker();
    _ticker?.muted = false;
    _expectedDelta = 1.0 / frameRate;
  }

  // Pauses the execution of this [Ticker]. This is equivalent to calling
  // [Ticker::muted] with `true`.
  void pause() {
    if (!isTicking) return;
    _ticker?.muted = true;
  }

  /// process timeframe in integer MS
  double _currentTime = 0;
  double _currentDeltaTime = 0;

  // 0-100%
  double _currentDeltaRatio = 0.0;

  double frameRate = 60.0;
  late double _expectedDelta;

  /// enterframe ticker
  void _onTick(Duration elapsed) {
    var now = elapsed.inMilliseconds.toDouble() * .001;
    _currentDeltaTime = (now - _currentTime);
    _currentTime = now;

    /// avoid overloading frames (happens per scene).
    _currentDeltaTime = _currentDeltaTime.clamp(1.0 / frameRate, 1.0);
    _currentDeltaRatio = _currentDeltaTime / _expectedDelta;

    if (_nextFrameCallback != null) {
      var callback = _nextFrameCallback;
      _nextFrameCallback = null;
      callback?.call();
    }
    onFrame.dispatch(_currentDeltaTime);
//    advanceTime(_currentDeltaTime);
//    render();
  }

  void dispose() {
    onFrame.removeAll();
    // onFrame = null;
    _ticker?.stop(canceled: true);
    _ticker?.dispose();
    _ticker = null;
  }
}

Stopwatch _stopwatch = Stopwatch();

int getTimer() {
  if (!_stopwatch.isRunning) _stopwatch.start();
  return _stopwatch.elapsedMilliseconds;
}
