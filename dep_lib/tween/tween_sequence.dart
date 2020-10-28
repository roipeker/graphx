import 'package:graphx/graphx/tween/gx_tween.dart';
import 'package:graphx/graphx/tween/tween_step.dart';
import 'package:graphx/graphx/tween/tween_timeline.dart';

class TweenSequence {
  TweenSequence _poolNext;
  static TweenSequence _poolFirst;
  static TweenSequence getPoolInstance() {
    TweenSequence seq;
    if (_poolFirst == null) {
      seq = TweenSequence();
    } else {
      seq = _poolFirst;
      _poolFirst = _poolFirst._poolNext;
      seq._poolNext = null;
    }
    return seq;
  }

  TweenStep _firstStep;
  TweenStep _currentStep;
  TweenStep _lastStep;

  TweenStep getLastStep() => _lastStep;
  int _stepCount = 0;
  bool _running = false;

  TweenTimeline timeline;
  bool _complete;
  bool isComplete() => _complete;

  void dispose() {
    while (_currentStep != null) {
      TweenStep step = _currentStep;
      removeStep(step);
      step.dispose();
    }
    _currentStep = null;
    _lastStep = null;
    _stepCount = 0;
    _complete = false;
    _running = false;

    timeline = null;
    if (GxTween.enablePooling) {
      _poolNext = _poolFirst;
      _poolFirst = this;
    }
  }

  double update(double delta) {
    if (!_running) return delta;
    var rest = delta;
    while (rest > 0 && _currentStep != null) {
      rest = _currentStep.update(rest);
    }
    if (_currentStep == null) finish();
    return rest;
  }

  void finish() {
    timeline.$dirty = true;
    _complete = true;
  }

  TweenStep addStep(TweenStep tween) {
    tween.$sequence = this;
    if (_currentStep == null) {
      _firstStep = _lastStep = _currentStep = tween;
    } else {
      _lastStep.$next = tween;
      tween.$previous = _lastStep;
      _lastStep = tween;
    }
    _stepCount++;
    return tween;
  }

  void nextStep() {
    _currentStep = _currentStep.$next;
  }

  void removeStep(TweenStep tween) {
    _stepCount--;
    if (_firstStep == tween) _firstStep = _firstStep.$next;
    if (_currentStep == tween) _currentStep = tween.$next;
    if (_lastStep == tween) _lastStep = tween.$previous;
    if (tween.$previous != null) tween.$previous.$next = tween.$next;
    if (tween.$next != null) tween.$next.$previous = tween.$previous;
  }

  void skipCurrent() => _currentStep?.skip();

  void abort() {
    timeline?.removeSequence(this);
  }

  // bind to gui

  void run() {
    _running = true;
  }

  void repeat() {
    _currentStep = _firstStep;
  }

  TweenStep getStepById(String stepId) {
    var step = _firstStep;
    if (stepId != '') {
      while (step != null) {
        if (step.stepId == stepId) {
          break;
        } else {
          step = step.$next;
        }
      }
    }
    return step;
  }

  void goto(TweenStep step) {
    if (step == null) {
      print("Connot go to null step.");
    } else {
      _currentStep = step;
    }
  }

  void reset() {
    TweenStep step = _firstStep;
    while (step != null) {
      step.reset();
      step.currentGotoRepeatCount = 0;
      step = step.$next;
    }
    _currentStep = _firstStep;
  }

  void retarget(dynamic target) {
    TweenStep step = _firstStep;
    while (step != null) {
      step.$target = target;
      step = step.$next;
    }
  }

  /// prototype code unnecesary.
}
