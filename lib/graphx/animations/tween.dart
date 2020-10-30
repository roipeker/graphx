import 'dart:math';

import 'package:graphx/graphx/events/mixins.dart';
import 'package:graphx/graphx/events/signal_data.dart';

import 'updatable.dart';

class GxTween with IUpdatable, JugglerSignalMixin {
  Map<String, double> target;
  JugglerObjectEventData _eventData;

  double currentTime;
  double totalTime;
  double progress;
  double repeatDelay;
  double _delay;
  int currentCycle, repeatCount;

  bool reverse = false;
  bool roundValue = false;

  GxTween nextTween;

  Function onStart;
  Function onUpdate;
  Function onRepeat;
  Function onComplete;

  double Function(double) transitionFun;

  List<Function(String, double, double)> updateFuncs = [];

  List<String> properties = <String>[];
  List<double> startValues = <double>[];
  List<double> endValues = <double>[];

  GxTween(Map<String, double> target, double time, [Function transition]) {
    _eventData = JugglerObjectEventData(this);
    reset(target, time, transition);
  }

  GxTween reset(Map<String, double> target, double time,
      [Function transition]) {
    this.target = target;
    currentTime = 0.0;
    onRemovedFromJuggler.id = 1;
    totalTime = max(time, .0001);
    onUpdate = onStart = onRepeat = onComplete = null;
    reverse = false;
    roundValue = false;
    progress = 0.0;
    _delay = repeatDelay = 0.0;
    repeatCount = 1;
    currentCycle = -1;
    nextTween = null;
    transitionFun = transition;
    updateFuncs.clear();
    properties.clear();
    startValues.clear();
    endValues.clear();
    return this;
  }

  void animate(String prop, double endValue) {
    int pos = properties.length;
    Function updateFun = getUpdateFuncFromProperty(prop);
//    properties[pos] = getPropertyName(prop);
//    startValues[pos] = double.nan;
//    endValues[pos] = endValue;
//    updateFuncs[pos] = updateFun;
    properties.insert(pos, getPropertyName(prop));
    startValues.insert(pos, double.nan);
    endValues.insert(pos, endValue);
    updateFuncs.insert(pos, updateFun);
  }

  void scaleTo(double factor) {
    animate('scaleX', factor);
    animate('scaleY', factor);
  }

  void moveTo(double x, double y) {
    animate('x', x);
    animate('y', y);
  }

  void fadeTo(double alpha) {
    animate('alpha', alpha);
  }

  @override
  void update(double delta) {
    if (delta == 0 || (repeatCount == 1 && currentTime == totalTime)) return;
//    print('update::: $delta -- $currentTime / $totalTime!');
    double previousTime = currentTime;
    double restTime = totalTime - currentTime;
    double carryOverTime = delta > restTime ? delta - restTime : 0.0;

    currentTime += delta;

    /// delay not over yet.
    if (currentTime <= 0) return;

    if (currentTime > totalTime) {
      currentTime = totalTime;
    }

    if (currentCycle < 0 && previousTime <= 0 && currentTime > 0) {
      currentCycle++;
      onStart?.call();
    }

    var ratio = currentTime / totalTime;
    var reversed = reverse && currentCycle % 2 == 1;
    var numProps = startValues.length;
//    print(
//        "currentime: $currentTime /// $delta / $totalTime /// $transitionFun");
    progress = reversed ? transitionFun(1.0 - ratio) : transitionFun(ratio);

    for (var i = 0; i < numProps; ++i) {
      if (startValues[i].isNaN) {
        startValues[i] = target[properties[i]];
      }

      /// update function callback?
      var updateFunc = updateFuncs[i];
      updateFunc?.call(properties[i], startValues[i], endValues[i]);
    }
    onUpdate?.call();

    if (previousTime < totalTime && currentTime >= totalTime) {
      if (repeatCount == 0 || repeatCount > 1) {
        currentTime = -repeatDelay;
        currentCycle++;
        if (repeatCount > 1) {
          repeatCount--;
        }
        onRepeat?.call();
      } else {
        // save callback and args, they might change through events.
        var $onComplete = onComplete;

        /// if people wanna call [tween.reset()] while [onComplete] and add it
        /// to another juggler, this has to be dispatched before executing
        /// [onComplete()]
//        print("REMOVED!!!!!!!!! pre... ${onRemovedFromJuggler.hasListeners()}");
        onRemovedFromJuggler.dispatch(_eventData);
//        currentTime = 0;
//        print("REMOVED!!!!!!!!! so... $currentTime");
        $onComplete?.call();
        if (currentTime == 0) {
          carryOverTime = 0;
        }
      }
    }
    if (carryOverTime > 0) {
//      print('carry over:: $carryOverTime');
      update(carryOverTime);
    }
  }

  /// the end value of certain property is being animated.
  double getEndValue(String property) {
    var index = properties.indexOf(property);
    if (index == -1) throw "The property '$property' is not animated";
    return endValues[index];
  }

  /// indicates if this tween is animating the property.
  bool isAnimatingProperty(String property) =>
      properties.indexOf(property) > -1;

  bool get isComplete => currentTime >= totalTime && repeatCount == 1;

  double get delay => _delay;

  set delay(double value) {
    currentTime += _delay - value;
    _delay = value;
  }

  static List<GxTween> _pool = [];

  static void toPool(GxTween obj) {
    /// reset all references to make sure is garbage collected.
    obj.onStart = obj.onUpdate = obj.onComplete = obj.onRepeat = null;
    obj.target = null;
    obj.transitionFun = null;

    /// remove next frame.
//    Future.delayed(Duration.zero, () {
    obj.$onRemovedFromJuggler?.removeAll();
//    });
    _pool.add(obj);
  }

  static GxTween fromPool(Map<String, double> target, double time,
      [Function transition]) {
    if (_pool.isNotEmpty)
      return _pool.removeLast().reset(target, time, transition);
    return GxTween(target, time, transition);
  }

  Function getUpdateFuncFromProperty(String prop) {
    /// special properties handling.
    Function updateFunc;

    /// add angle later.
    updateFunc = updateStandard;
    return updateFunc;
  }

  void updateStandard(String prop, double start, double end) {
    double value = start + progress * (end - start);
    if (roundValue) {
      value = value.roundToDouble();
    }
    target[prop] = value;
  }

  void updateRgb(String prop, double start, double end) {
    target[prop] = _ColorUtils.interpolate(start.toInt(), end.toInt(), progress)
        .toDouble();
  }

  void updateRad(String prop, double start, double end) {
    updateAngle(pi, prop, start, end);
  }

  void updateDeg(String prop, double start, double end) {
    updateAngle(180, prop, start, end);
  }

  void updateAngle(double $pi, String prop, double start, double end) {
    while ((end - start).abs() > $pi) {
      if (start < end) {
        end -= 2.0 * $pi;
      } else {
        end += 2.0 * $pi;
      }
    }
    updateStandard(prop, start, end);
  }

  /// Access to get special properties like color, rotation, etc.
  static String getPropertyName(String prop) => prop;

  /// TODO: implement custom access to properties, like reflection.
  bool hasSpecialProperty(String prop) {
    return false;
  }

  void setSpecialProperty(String prop, dynamic value) {}
}

class GxTweenProps {
  Function onUpdate;
  Function onComplete;
  double delay;

  GxTweenProps({this.delay, this.onComplete, this.onUpdate});
}

class _ColorUtils {
  static int interpolate(int from, int to, double progress) {
    return from;
  }
}
