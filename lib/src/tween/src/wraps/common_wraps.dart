part of gtween;

/// Common tweenable wrappers for GraphX
abstract class CommonTweenWraps {
  /// TODO: check performance to use a Custom mapping type.
  /// Lerps (like Color) are managed separately.
  static Map<String, List<Function>> displayObject(GDisplayObject? o) {
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

class GTweenableDouble with GTweenable, SingleValueTweenMixin {
  static GTweenable? wrap(Object? target) =>
      target is double ? GTweenableDouble(target) : null;

  double? value;

  GTweenableDouble(double target) {
    value = this.target = target;
  }

  @override
  Map<String, List<Function>> getTweenableAccessors() => {
        'value': [() => value, (v) => value = v],
      };

  @override
  String toString() => '[GTweenableDouble] $value';
}

class GTweenableInt with GTweenable, SingleValueTweenMixin {
  static GTweenable? wrap(Object? target) =>
      target is int ? GTweenableInt(target) : null;

  int? value;

  GTweenableInt(int target) {
    value = this.target = target;
  }

  @override
  Map<String, List<Function>> getTweenableAccessors() => {
        'value': [
          () => value! + .0,
          (v) => value = v.round(),
        ],
      };

  @override
  String toString() => '[GTweenableInt] $value';
}

class GTweenableMap with GTweenable {
  static GTweenable? wrap(Object? target) =>
      target is Map<String?, dynamic> ? GTweenableMap(target) : null;

  late Map value;

  GTweenableMap(Map target) {
    value = this.target = target;
  }

  @override
  void setProperty(Object? prop, double val) {
    value[prop] = convertFromDouble(value[prop], val);
  }

  @override
  double getProperty(Object prop) {
    return convertToDouble(value[prop]);
  }

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
//          vars: vars,
          runBackwards: runBackwards,
          immediateRender: immediateRender,
          startAt: startAt,
        ));
  }
}

class GTweenableList with GTweenable {
  static GTweenable? wrap(Object? target) {
    if (target is! List) return null;
    return GTweenableList(target);
  }

  late List value;

  GTweenableList(List target) {
    value = this.target = target;
  }

  @override
  void setProperty(Object? prop, double val) {
    final index = int.tryParse('$prop')!;
    value[index] = convertFromDouble(value[index], val);
  }

  @override
  double getProperty(Object prop) {
    return convertToDouble(value[int.parse('$prop')]);
  }

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
//          vars: vars,
          runBackwards: runBackwards,
          immediateRender: immediateRender,
          startAt: startAt,
        ));
  }
}

Object convertFromDouble(Object? originalValue, double val) {
  if (originalValue is int) {
    return val.toInt();
  } else if (originalValue is String) {
    return '$val';
  } else {
    return val;
  }
}

double convertToDouble(Object? val) {
  if (val is int) {
    return val + .0;
  } else if (val is String) {
    return double.tryParse(val) as double;
  }
  return val as double;
}

mixin SingleValueTweenMixin {
  Object? getValue;

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
//          vars: vars,
          runBackwards: runBackwards,
          immediateRender: immediateRender,
          startAt: startAt,
        ));
  }
}
