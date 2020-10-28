import 'dart:math';

import 'package:graphx/graphx/tween/gx_tween.dart';
import 'package:graphx/graphx/tween/interp/float_interp.dart';
import 'package:graphx/graphx/tween/tween_interp.dart';
import 'package:graphx/graphx/tween/tween_sequence.dart';

class TweenStep {
  TweenStep _poolNext;
  static TweenStep _poolFirst;

  static TweenStep getPoolInstance() {
    TweenStep seq;
    if (_poolFirst == null) {
      seq = TweenStep();
    } else {
      seq = _poolFirst;
      _poolFirst = _poolFirst._poolNext;
      seq._poolNext = null;
    }
    return seq;
  }

  TweenSequence $sequence;
  TweenStep $previous;
  TweenStep $next;
  double time;
  List<TweenInterp> $interps;

  String stepId = '';
  String gotoStepId = '';
  double duration;
  int gotoRepeatCount = 0;
  int currentGotoRepeatCount = 0;
  dynamic $target;

  String targetId;
  TweenInterp $lastInterp;

  Function $onComplete;
  List $onCompleteArgs;
  Function $onUpdate;
  List $onUpdateArgs;
  bool _empty;

  dynamic getTarget() => $target;

  TweenSequence getSequence() => $sequence;

  TweenStep() {
    time = duration = 0;
    _empty = true;
  }

  TweenStep addInterp(TweenInterp value) {
    $interps ??= [];
    duration = max(duration, value.duration);
    $lastInterp = value;
    $interps.add(value);
    _empty = false;
    return this;
  }

  TweenStep onUpdate(Function callback, [List args]) {
    $onUpdateArgs = args;
    $onUpdate = callback;
    return this;
  }

  TweenStep onComplete(Function callback, [List args]) {
    $onCompleteArgs = args;
    $onComplete = callback;
    return this;
  }

  void skip() {
    if ($interps != null) {
      for (var i in $interps) {
        i.setValue(i.getFinalValue());
      }
    }
    _finish();
  }

  void _finish() {
    print("finish and reset!");
    reset();
    if ($sequence == null) return;
    if (currentGotoRepeatCount < gotoRepeatCount) {
      currentGotoRepeatCount++;
      $sequence.goto($sequence.getStepById(gotoStepId));
    } else {
      /// reflection not possible.
      $onComplete?.call();
      currentGotoRepeatCount = 0;
      if ($sequence != null) {
        $sequence.nextStep();
      }
    }
  }

  void dispose() {
    $sequence = null;
    $previous = null;
    $next = null;
    $interps?.clear();
    $interps = null;
    $lastInterp = null;
    time = duration = 0;
    _empty = true;
    $onComplete = null;
    $onUpdate = null;
    targetId = '';
    $target = null;
    gotoStepId = '';
    gotoRepeatCount = 0;
    currentGotoRepeatCount = 0;

    if (GxTween.enablePooling) {
      /// back to pool
      _poolNext = _poolFirst;
      _poolFirst = this;
    }
  }

  double update(double delta) {
    var rest = 0.0;
    if ($interps != null) {
      print("Interps: ${$interps.length}");
      for (var i in $interps) {
        i.update(delta);
      }
    }
    time += delta;
    if (time > duration) {
      rest = time - duration;
      time = duration;
    }
    $onUpdate?.call();
    if (time > duration) {
      _finish();
    }
    return rest;
    // return 0;
  }

  TweenStep delay(double duration) {
    TweenStep step = _empty ? this : $sequence.addStep(getPoolInstance());
    step.duration = duration;
    _empty = false;
    step = $sequence.addStep(getPoolInstance());
    step.$target = $target;
    step.targetId = targetId;
    return step;
  }

  TweenStep id(String pid) {
    stepId = pid;
    return this;
  }

  TweenStep propF(String prop, double to, double duration, bool relative) {
    FloatInterp i = FloatInterp(this);
    i.relative = relative;
    i.property = prop;
    i.duration = duration;
    i.to = to;
    return addInterp(i);
  }

  TweenStep create(dynamic target) {
    var step = $sequence.addStep(getPoolInstance());
    if (target is String) {
      step.targetId = target as String;
    } else {
      step.$target = target;
    }
    return step;
  }

  TweenStep extend() {
    TweenStep step = $sequence.addStep(getPoolInstance());
    step.$target = $target;
    step.targetId = targetId;
    return step;
  }

  TweenStep goto(String stepId, int repeatCount) {
    gotoRepeatCount = repeatCount;
    gotoStepId = stepId;
    return this;
  }

  void reset() {
    time = 0;
    print("reset!");
    if ($interps != null) {
      for (var i in $interps) {
        i.reset();
      }
    }
  }

  /// prototype.
}
