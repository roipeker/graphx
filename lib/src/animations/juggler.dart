import '../../graphx/animations/tween.dart';
import '../../graphx/events/mixins.dart';
import '../../graphx/events/signal_data.dart';
import 'delayed_call.dart';
import 'updatable.dart';

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
        (obj as JugglerSignalMixin)?.$onRemovedFromJuggler?.addOnce(_onRemove);
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
    int objId = 0;
    if (obj != null && objectsIds.containsKey(obj)) {
      /// check if it has events.
      if (obj is JugglerSignalMixin) {
        (obj as JugglerSignalMixin)?.$onRemovedFromJuggler?.remove(_onRemove);
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
      IUpdatable obj = objects[i];
      if (objectsIds[obj] == objId) {
        remove(obj);
        return objId;
      }
    }
    return 0;
  }

  /// remove all tween by target.
  void removeTweens(Object target) {
    if (target == null) return;
    for (var i = 0; i < objects.length; ++i) {
      /// var tween
      var obj = objects[i];
      if (obj is GxTween) {
        var tween = obj as GxTween;
        if (tween.target == target) {
          tween.$onRemovedFromJuggler?.remove(_onRemove);
          objects[i] = null;
          objectsIds.remove(obj);
        }
      }
    }
  }

  /// remove all delayed and repeated calls with a certains callback.
  void removeDelayedCalls(Function callback) {
    if (callback == null) return;
    for (var i = 0; i < objects.length; ++i) {
      var obj = objects[i];
      if (obj is GxDelayedCall && obj.target == callback) {
        obj.$onRemovedFromJuggler?.remove(_onRemove);
        objects[i] = null;
        objectsIds.remove(obj);
      }
    }
  }

  /// checks if the juggler contains one or more tweens with the certain target.
  bool containsTween(Object target) {
    if (target == null) return false;
    for (var i = 0; i < objects.length; ++i) {
      var obj = objects[i];
      if (obj is GxTween && (obj as GxTween).target == target) return true;
    }
    return false;
  }

  /// checks if the juggler contains one or more delayed calls with the certain target.
  bool containsDelayedCalls(Function callback) {
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

  int delayedCall(Function callback, double delay) {
    if (callback == null) throw 'callback can not be null';
    GxDelayedCall obj = GxDelayedCall.fromPool(callback, delay);
    obj.onRemovedFromJuggler.add(_onPoolDelayedCallComplete);
    return add(obj);
  }

  int repeatCall(Function callback, double delay, [int repeatCount = 0]) {
    if (callback == null) throw 'callback can not be null';
    var obj = GxDelayedCall.fromPool(callback, delay)
      ..repeatCount = repeatCount
      ..onRemovedFromJuggler.add(_onPoolDelayedCallComplete);
    return add(obj);
  }

  void _onPoolTweenComplete(JugglerObjectEventData e) {
    GxTween.toPool(e.target as GxTween);
  }

  void _onPoolDelayedCallComplete(JugglerObjectEventData e) {
    GxDelayedCall.toPool(e.target as GxDelayedCall);
  }

  /// TODO: add proper tweens properties.
  int tween(Object target, double time) {
    if (target == null) throw 'target must not be null';
    var obj = GxTween.fromPool(target, time);

    /// TODO: for each prop do something.
    obj.onRemovedFromJuggler.add(_onPoolTweenComplete);
    return add(obj);
  }

  /// advanced the objects by the specific time (in seconds).
  void update(double time) {
    var numObjects = objects.length;
    var currentIndex = 0;
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
    if (objId != 0) {
      if (data.target is GxTween) {
        var obj = data.target as GxTween;
        if (obj.isComplete) {
          addWithId(obj.nextTween, objId);
        }
      }
    }
  }
}
