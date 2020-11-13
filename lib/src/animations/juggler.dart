// import 'dart:html';

import '../../graphx.dart';

class Juggler {
  static int _currentObjectId = 0;
  final objects = <IUpdatable>[];
  final objectsIds = <IUpdatable, int>{};
  double _elapsed = 0;
  double timeScale = 1;

  double get elapsedTime => _elapsed;

  static int _getNextId() => ++_currentObjectId;

  int add(IUpdatable obj) => addWithId(obj, _getNextId());

  /// returns the id for the animation, can be used to remove the animation
  /// with [removeById()].
  int addWithId(IUpdatable obj, int id) {
    if (obj != null && !objectsIds.containsKey(obj)) {
      /// check if it has events.
      if (obj is JugglerSignalMixin) {
        (obj as JugglerSignalMixin)?.onRemovedFromJuggler?.add(_onRemove);
      }
      objects.add(obj);
      objectsIds[obj] = id;
      return id;
    }
    return 0;
  }

  /// tells you if the object has been added to the Jugger.
  bool contains(IUpdatable obj) => objectsIds.containsKey(obj);

  int remove(IUpdatable obj) {
    var objId = 0;
    if (obj != null && objectsIds.containsKey(obj)) {
      /// check if it has events.
      if (obj is JugglerSignalMixin) {
        (obj as JugglerSignalMixin).onRemovedFromJuggler.remove(_onRemove);
      }
      var index = objects.indexOf(obj);
      objects[index] = null;
      objId = objectsIds[obj];
      objectsIds.remove(obj);
    }
    return objId;
  }

  int removeById(int objId) {
    for (var i = 0; i < objects.length; ++i) {
      final obj = objects[i];
      if (objectsIds[obj] == objId) {
        remove(obj);
        return objId;
      }
    }
    return 0;
  }

//  /// remove all tween by target.
//  void removeTweens(Object target) {
//    if (target == null) return;
//    for (var i = 0; i < objects.length; ++i) {
//      /// var tween
//      var obj = objects[i];
//      if (obj is GxTween) {
//        var tween = obj;
//        if (tween.target == target) {
//          tween.onRemovedFromJuggler.remove(_onRemove);
//          objects[i] = null;
//          objectsIds.remove(obj);
//        }
//      }
//    }
//  }

  /// remove all delayed and repeated calls with a certains callback.
  void removeDelayedCalls(Function callback) {
    if (callback == null) return;
    for (var i = 0; i < objects.length; ++i) {
      var obj = objects[i];
      if (obj is GxDelayedCall && obj.target == callback) {
        obj.onRemovedFromJuggler.remove(_onRemove);
        objects[i] = null;
        objectsIds.remove(obj);
      }
    }
  }

  /// checks if the juggler contains one or more tweens with the certain target.
//  bool containsTween(Object target) {
//    if (target == null) return false;
//    for (var i = 0; i < objects.length; ++i) {
//      var obj = objects[i];
//      if (obj is GxTween && obj.target == target) return true;
//    }
//    return false;
//  }

  /// checks if the juggler contains one or more delayed calls with the certain target.
  bool containsDelayedCalls(VoidCallback callback) {
    if (callback == null) return false;
    for (var i = 0; i < objects.length; ++i) {
      var obj = objects[i];
      if (obj is GxDelayedCall && obj.target == callback) return true;
    }
    return false;
  }

  /// removes all objects at once.
  void purge() {
    for (var i = 0; i < objects.length; ++i) {
      var obj = objects[i];
      if (obj is JugglerSignalMixin) {
        (obj as JugglerSignalMixin).$onRemovedFromJuggler?.remove(_onRemove);
      }
      objects[i] = null;
      objectsIds.remove(obj);
    }
  }

  int delayedCall(VoidCallback callback, double delay) {
    if (callback == null) throw 'callback can not be null';
    final obj = GxDelayedCall.fromPool(callback, delay);
    obj.onRemovedFromJuggler.add(_onPoolDelayedCallComplete);
    return add(obj);
  }

  int repeatCall(VoidCallback callback, double delay, [int repeatCount = 0]) {
    if (callback == null) throw 'callback can not be null';
    var obj = GxDelayedCall.fromPool(callback, delay)
      ..repeatCount = repeatCount
      ..onRemovedFromJuggler.add(_onPoolDelayedCallComplete);
    return add(obj);
  }

  void _onPoolDelayedCallComplete(JugglerObjectEventData e) {
    GxDelayedCall.toPool(e.target as GxDelayedCall);
  }

  /// TODO: add proper tweens properties.
  /// and evaluate target as Object and map as required with reflection.
//  int tween(
//    Map<String, dynamic> target,
//    double time,
//    Map<String, dynamic> properties, {
//    double delay = 0,
//    EaseFunction ease,
//    Function onComplete,
//    Function onUpdate,
//    Function onStart,
//  }) {
//    if (target == null) throw 'target must not be null';
//    ease ??= GxEase.defaultEasing;
//    var obj = GxTween.fromPool(target, time, ease);
//    for (var prop in properties.keys) {
//      var value = properties[prop];
//      if (obj.hasSpecialProperty(prop)) {
//        obj.setSpecialProperty(prop, value);
//      } else if (target.containsKey(GxTween.getPropertyName(prop))) {
//        obj.animate(prop, value as double);
//      } else {
//        throw "Invalid property: '$prop'";
//      }
//    }
//    obj.delay = delay;
//    obj.transitionFun = ease;
//    obj.onStart = onStart;
//    obj.onComplete = onComplete;
//    obj.onUpdate = onUpdate;
//    var id = add(obj);
//    obj.onRemovedFromJuggler.add(_onPoolTweenComplete);
//    return id;
//  }
//
//  GxTween getTweenById(int id) {
//    for (var i = 0; i < objects.length; ++i) {
//      var obj = objects[i];
//      if (objectsIds[obj] == id) return obj;
//    }
//    return null;
//  }
//
//  void _onPoolTweenComplete(JugglerObjectEventData e) {
//    GxTween.toPool(e.target as GxTween);
//  }

  /// advanced the objects by the specific time (in seconds).
  void update(double time) {
    var numObjects = objects.length;
    var currentIndex = 0;
//    print('update objects::: $numObjects');

    int i;
    _elapsed += time;
    time *= timeScale;
    if (numObjects == 0 || time == 0) return;

    /// [update] function can modify the animatables list, so we process it
    /// in the next frame, we need to clean up empty slots in the list.
    for (i = 0; i < numObjects; ++i) {
      var obj = objects[i];
      if (obj != null) {
        // shift objects into empty slots.
        if (currentIndex != i) {
          objects[currentIndex] = obj;
          objects[i] = null;
        }
        obj.update(time);
        ++currentIndex;
      }
    }

    if (currentIndex != i) {
      /// num objects can change.
      numObjects = objects.length;
      while (i < numObjects) {
        objects[currentIndex++] = objects[i++];
      }
      objects.length = currentIndex;
    }
  }

  void _onRemove(JugglerObjectEventData data) {
    int objId = remove(data.target);
    if (objId != 0) {}
  }
}
