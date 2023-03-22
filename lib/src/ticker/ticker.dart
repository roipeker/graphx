import 'package:flutter/scheduler.dart';

import '../events/events.dart';

/// A [Stopwatch] object used for measuring elapsed time.
Stopwatch _stopwatch = Stopwatch();

/// Returns the elapsed time since the start of the GraphX scene in
/// milliseconds, or 0 if it hasn't been started yet.
///
/// This function is equivalent to the `getTimer()` function in ActionScript or
/// JS. If the stopwatch is not running, it starts it automatically.
int getTimer() {
  if (!_stopwatch.isRunning) {
    _stopwatch.start();
  }
  return _stopwatch.elapsedMilliseconds;
}

/// [GTicker] provides a way to schedule callbacks that will be executed on
/// every frame. In GraphX, [GTicker] is used at the core to update the
/// DisplayObject tree and the inner Ticker that runs it, also invalidates the
/// rendering for the CustomPainter through the [ScenePainter] when
/// [SceneConfig.autoUpdateRender], is `true`.
///
/// The [GTicker] class internally creates a [Ticker] (provided the Flutter).
/// On each tick, it calculates the elapsed time and the delta time
/// between the current and previous frames. It also dispatches the [onFrame]
/// signal, which is used to update the DisplayObject tree.
///
/// It is important to note that [GTicker] is not meant to be used directly by
/// the user, as it is used internally by the GraphX framework.
///
class GTicker {
  /// The [Ticker] object used for managing frame updates.
  Ticker? _ticker;

  /// Signal dispatched on every frame with the elapsed time since the last
  /// frame as a parameter.
  final onFrame = EventSignal<double>();

  /// Callback to be executed on the next frame.
  VoidCallback? _nextFrameCallback;

  /// The current time in seconds.
  double _currentTime = 0;

  /// The time elapsed since the last frame in seconds.
  double _currentDeltaTime = 0;

  /// The ratio of the current delta time to the expected delta time.
  /// In a range of [0-1]
  double _currentDeltaRatio = 0.0;

  /// The frame rate of the [Ticker] in frames per second.
  double frameRate = 60.0;

  /// The expected delta time based on the current frame rate.
  late double _expectedDelta;

  /// Creates a [GTicker].
  GTicker();

  /// The ratio of the current delta time to the expected delta time.
  double get currentDeltaRatio {
    return _currentDeltaRatio;
  }

  /// The time elapsed since the last frame in seconds.
  double get currentDeltaTime {
    return _currentDeltaTime;
  }

  /// The current time in seconds.
  double get currentTime {
    return _currentTime;
  }

  /// Indicates whether the [Ticker] is currently active or not.
  /// Whether time is elapsing for this [Ticker].
  /// Becomes true when [start] is called and false when [stop] is called.
  bool get isActive {
    return _ticker?.isActive ?? false;
  }

  /// Indicates whether the [Ticker] is currently ticking or not.
  bool get isTicking {
    return _ticker?.isTicking ?? false;
  }

  /// Schedules [callback] to be executed on the next frame.
  // ignore: use_setters_to_change_properties
  void callNextFrame(VoidCallback callback) {
    _nextFrameCallback = callback;
  }

  /// Removes all listeners from the [onFrame] signal and disposes the [Ticker]
  /// object.
  void dispose() {
    onFrame.removeAll();
    _ticker?.stop(canceled: true);
    _ticker?.dispose();
    _ticker = null;
  }

  /// Pauses the [Ticker] if it's currently ticking.
  /// This is equivalent to calling
  /// [Ticker.muted] with `true`.
  void pause() {
    if (!isTicking) {
      return;
    }
    _ticker?.muted = true;
  }

  /// Resumes the [Ticker] if it's not currently ticking.
  /// This is equivalent to calling [Ticker.muted] with `false`.
  void resume() {
    if (isTicking) {
      return;
    }
    _createTicker();
    _ticker?.muted = false;
    _expectedDelta = 1.0 / frameRate;
  }

  /// Creates a [Ticker] object if it hasn't been created yet, and starts it if
  /// it's not ticking.
  void _createTicker() {
    if (_ticker != null) return;
    _ticker = Ticker(_onTick);
    _ticker!.start();
    _ticker!.muted = true;
  }

  /// The callback method that is called on every frame update.
  /// Mimics the `onEnterFrame` in AS3.
  void _onTick(Duration elapsed) {
    var now = elapsed.inMilliseconds.toDouble() * .001;
    _currentDeltaTime = (now - _currentTime);
    _currentTime = now;

    /// Avoid overloading frames (happens per scene).
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
}
