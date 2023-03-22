part of gtween;

/// Converts a double [target] value to its corresponding type.
///
/// If the [original] is of type int, the double value is converted to int. If
/// the [original] is of type String, the double value is converted to String.
/// Otherwise, the original double value is returned as is.
Object convertFromDouble(Object? original, double target) {
  if (original is int) {
    return target.toInt();
  } else if (original is String) {
    return '$target';
  } else {
    return target;
  }
}

/// Converts a [value] to a double type.
///
/// If the [value] is of type int, it is converted to double. If the [value] is
/// of type String, it is parsed to double using double.tryParse(). Otherwise,
/// the original value is returned as double.
double convertToDouble(Object? value) {
  if (value is int) {
    return value + .0;
  } else if (value is String) {
    return double.tryParse(value) as double;
  }
  return value as double;
}

/// Contains static methods that return a map of properties and accessors for
/// tweening a [GDisplayObject]. Common tweenable wrappers for GraphX
///
abstract class CommonTweenWraps {
  /// Returns a map of properties and accessors for tweening a [GDisplayObject].
  ///
  /// The returned map contains the following properties and their corresponding
  /// accessors:
  ///
  /// * 'x': [GDisplayObject.x] and [GDisplayObject.x=]
  /// * 'y': [GDisplayObject.y] and [GDisplayObject.y=]
  /// * 'scaleX': [GDisplayObject.scaleX] and [GDisplayObject.scaleX=]
  /// * 'scaleY': [GDisplayObject.scaleY] and [GDisplayObject.scaleY=]
  /// * 'scale': [GDisplayObject.scale] and [GDisplayObject.scale=]
  /// * 'rotation': [GDisplayObject.rotation] and [GDisplayObject.rotation=]
  /// * 'rotationX': [GDisplayObject.rotationX] and [GDisplayObject.rotationX=]
  /// * 'rotationY': [GDisplayObject.rotationY] and [GDisplayObject.rotationY=]
  /// * 'pivotX': [GDisplayObject.pivotX] and [GDisplayObject.pivotX=]
  /// * 'pivotY': [GDisplayObject.pivotY] and [GDisplayObject.pivotY=]
  /// * 'width': [GDisplayObject.width] and [GDisplayObject.width=]
  /// * 'height': [GDisplayObject.height] and [GDisplayObject.height=]
  /// * 'skewX': [GDisplayObject.skewX] and [GDisplayObject.skewX=]
  /// * 'skewY': [GDisplayObject.skewY] and [GDisplayObject.skewY=]
  /// * 'alpha': [GDisplayObject.alpha] and [GDisplayObject.alpha=]
  ///
  /// The returned map is a Map<String, List<Function>>, where each key-value pair
  /// represents a property and its corresponding accessors, respectively.
  /// Lerps (like [Color]) are managed separately.
  static Map<String, List<Function>> displayObject(GDisplayObject? o) {
    // TODO: check performance to use a Custom mapping type.
    return {
      'x': [() => o!.x, (v) => o!.x = v],
      'y': [() => o!.y, (v) => o!.y = v],
      'scaleX': [() => o!.scaleX, (v) => o!.scaleX = v],
      'scaleY': [() => o!.scaleY, (v) => o!.scaleY = v],
      'scale': [() => o!.scale, (v) => o!.scale = v],
      'rotation': [() => o!.rotation, (v) => o!.rotation = v],
      'rotationX': [() => o!.rotationX, (v) => o!.rotationX = v],
      'rotationY': [() => o!.rotationY, (v) => o!.rotationY = v],
      'pivotX': [() => o!.pivotX, (v) => o!.pivotX = v],
      'pivotY': [() => o!.pivotY, (v) => o!.pivotY = v],
      'width': [() => o!.width, (v) => o!.width = v],
      'height': [() => o!.height, (v) => o!.height = v],
      'skewX': [() => o!.skewX, (v) => o!.skewX = v],
      'skewY': [() => o!.skewY, (v) => o!.skewY = v],
      'alpha': [() => o!.alpha, (v) => o!.alpha = v],
    };
  }
}

//// ---------------------------------------------------------------------------

/// An implementation of [GTweenable] for double values.
///
/// It can be used to animate numeric values, such as the size of an object or
/// the position of a point.
class GTweenableDouble with GTweenable, SingleValueTweenMixin {
  /// The current value of the tweenable object.
  double value = 0.0;

  /// Creates a new [GTweenableDouble] object with the given [target] value.
  GTweenableDouble(double target) {
    value = this.target = target;
  }

  /// Returns a map of all available accessors for this instance of
  /// [GTweenableDouble]
  @override
  Map<String, List<Function>> getTweenableAccessors() {
    return {
      'value': [() => value, (v) => value = v],
    };
  }

  /// Returns a string representation of this instance of [GTweenableDouble]
  @override
  String toString() {
    return '[GTweenableDouble] $value';
  }

  /// Wraps the given [target] in a [GTweenableDouble] object if it is a double
  /// value, otherwise returns null.
  static GTweenable? wrap(Object? target) {
    return target is double ? GTweenableDouble(target) : null;
  }
}

//// ---------------------------------------------------------------------------

/// The GTweenableInt class is used as a mixin to provide the ability to animate
/// a single integer value. It wraps a single int value to be used by the GTween
/// class and implements the necessary methods to make it animatable.
///
class GTweenableInt with GTweenable, SingleValueTweenMixin {
  /// The integer value that is wrapped.
  int? value;

  /// Creates a new [GTweenableInt] instance with the specified integer [target].
  GTweenableInt(int target) {
    value = this.target = target;
  }

  /// Returns a map of tweenable accessors that GTween can use to animate the
  /// integer value.
  @override
  Map<String, List<Function>> getTweenableAccessors() {
    return {
      'value': [
        () => value! + .0,
        (v) => value = v.round(),
      ],
    };
  }

  /// Returns a string representation of the [GTweenableInt] instance.
  @override
  String toString() {
    return '[GTweenableInt] $value';
  }

  /// Wraps an integer value to be used as a target for [GTween] animations.
  static GTweenable? wrap(Object? target) {
    return target is int ? GTweenableInt(target) : null;
  }
}

//// ---------------------------------------------------------------------------

/// A class that wraps a List to be tweenable using [GTween].
///
class GTweenableList with GTweenable {
  /// This is the property that holds the actual list value that will be
  /// tweened.
  late List value;

  /// Creates a new [GTweenableList] instance with the specified target.
  GTweenableList(List target) {
    value = this.target = target;
  }

  @override
  double getProperty(Object property) {
    final idx = int.parse('$property');
    final output = convertToDouble(value[idx]);
    return output;
  }

  @override
  void setProperty(Object property, double targetValue) {
    final index = int.tryParse('$property')!;
    value[index] = convertFromDouble(value[index], targetValue);
  }

  /// Tweens the values in this list to the specified target values.
  ///
  /// The [targetList] argument should be a list of numeric values that has the
  /// same length as the list of values in this instance of [GTweenableList].
  ///
  /// Returns a [GTween] instance that represents the tween animation.
  GTween tween(
    List targetList, {
    required double duration,
    EaseFunction? ease,
    double? delay,
    bool? useFrames,
    int? overwrite,
    VoidCallback? onStart,
    Object? onStartParams,
    VoidCallback? onComplete,
    Object? onCompleteParams,
    VoidCallback? onUpdate,
    Object? onUpdateParams,
    bool? runBackwards,
    bool? immediateRender,
    Map? startAt,
  }) {
    targetList.removeWhere((element) => element is! num);
    if (targetList.isEmpty) {
      throw '''
tween(targetList) List can't be empty. Or values inside of it where not a number type''';
    }
    final targetMap = {};
    for (var i = 0; i < targetList.length; ++i) {
      targetMap[i] = targetList[i];
    }
    return GTween.to(
        this,
        duration,
        targetMap,
        GVars(
          ease: ease,
          delay: delay,
          useFrames: useFrames,
          overwrite: overwrite,
          onStart: onStart,
          onStartParams: onStartParams,
          onComplete: onComplete,
          onCompleteParams: onCompleteParams,
          onUpdate: onUpdate,
          onUpdateParams: onUpdateParams,
          runBackwards: runBackwards,
          immediateRender: immediateRender,
          startAt: startAt,
        ));
  }

  /// Returns an instance of [GTweenableList] if the given [target] object is a
  /// List, otherwise returns `null`.
  static GTweenable? wrap(Object? target) {
    if (target is! List) {
      return null;
    }
    return GTweenableList(target);
  }
}

//// ---------------------------------------------------------------------------

/// [GTweenableMap] is a class that implements [GTweenable] for
/// Map<String, dynamic> objects.
///
class GTweenableMap with GTweenable {
  /// The target Map to be tweened.
  late Map value;

  /// Creates a new [GTweenableMap] instance with the given [target].
  GTweenableMap(Map target) {
    value = this.target = target;
  }

  @override
  double getProperty(Object prop) {
    return convertToDouble(value[prop]);
  }

  @override
  void setProperty(Object? prop, double val) {
    value[prop] = convertFromDouble(value[prop], val);
  }

  /// Tweens the target [Map] to a specified [targetMap].
  ///
  /// The tween will animate the values of the [value] map to the corresponding
  /// values in the [targetMap]. The parameters are the same as the ones in the
  /// [GTween.to] method.
  ///
  /// Throws an error if the [targetMap] is empty or if there are no matching
  /// keys with the tweenable target.
  GTween tween(
    Map targetMap, {
    required double duration,
    EaseFunction? ease,
    double? delay,
    bool? useFrames,
    int? overwrite,
    VoidCallback? onStart,
    Object? onStartParams,
    VoidCallback? onComplete,
    Object? onCompleteParams,
    VoidCallback? onUpdate,
    Object? onUpdateParams,
    bool? runBackwards,
    bool? immediateRender,
    Map? startAt,
  }) {
    targetMap.removeWhere((k, v) => !value.containsKey(k));
    if (targetMap.isEmpty) {
      throw '''
tween(targetMap) Map can't be empty. Or there are no matching keys with the tweenable target.''';
    }

    return GTween.to(
      this,
      duration,
      targetMap,
      GVars(
        ease: ease,
        delay: delay,
        useFrames: useFrames,
        overwrite: overwrite,
        onStart: onStart,
        onStartParams: onStartParams,
        onComplete: onComplete,
        onCompleteParams: onCompleteParams,
        onUpdate: onUpdate,
        onUpdateParams: onUpdateParams,
        runBackwards: runBackwards,
        immediateRender: immediateRender,
        startAt: startAt,
      ),
    );
  }

  /// Creates a [GTweenable] instance of [GTweenableMap] from an object.
  ///
  /// Returns a [GTweenableMap] instance if the target object is a
  /// Map<String?,dynamic>, otherwise, returns null.
  static GTweenable? wrap(Object? target) {
    return target is Map<String?, dynamic> ? GTweenableMap(target) : null;
  }
}

//// ---------------------------------------------------------------------------

/// A mixin that adds the ability for the tweenable object to represent a single
/// value that is being tweened.
mixin SingleValueTweenMixin {
  /// The value to be tweened.
  /// Can be a [Function] or the actual value.
  Object? getValue;

  /// Tweens this instance (defined by [getValue]) to the current [value].
  ///
  /// Returns the created [GTween] instance.
  GTween tween(
    Object value, {
    required double duration,
    EaseFunction? ease,
    double? delay,
    bool? useFrames,
    int? overwrite,
    Function? onStart,
    Object? onStartParams,
    Function? onComplete,
    Object? onCompleteParams,
    Function? onUpdate,
    Object? onUpdateParams,
    bool? runBackwards,
    bool? immediateRender,
    Map? startAt,
  }) {
    return GTween.to(
      this,
      duration,
      {'value': value},
      GVars(
        ease: ease,
        delay: delay,
        useFrames: useFrames,
        overwrite: overwrite,
        onStart: onStart,
        onStartParams: onStartParams,
        onComplete: onComplete,
        onCompleteParams: onCompleteParams,
        onUpdate: onUpdate,
        onUpdateParams: onUpdateParams,
        runBackwards: runBackwards,
        immediateRender: immediateRender,
        startAt: startAt,
      ),
    );
  }
}
