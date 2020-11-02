part of gtween;

/// Common tweenable wrappers for GraphX
abstract class CommonTweenWraps {
  /// TODO: check performance to use a Custom mapping type.
  static Map<String, List<Function>> displayObject(DisplayObject o) {
    return {
      'x': [() => o.x, (v) => o.x = v],
      'y': [() => o.y, (v) => o.y = v],
      'scaleX': [() => o.scaleX, (v) => o.scaleX = v],
      'scaleY': [() => o.scaleY, (v) => o.scaleY = v],
      'scale': [() => o.scale, (v) => o.scale = v],
      'rotation': [() => o.rotation, (v) => o.rotation = v],
      'pivotX': [() => o.pivotX, (v) => o.pivotX = v],
      'pivotY': [() => o.pivotY, (v) => o.pivotY = v],
      'width': [() => o.width, (v) => o.width = v],
      'height': [() => o.height, (v) => o.height = v],
      'skewX': [() => o.skewX, (v) => o.skewX = v],
      'skewY': [() => o.skewY, (v) => o.skewY = v],
      'alpha': [() => o.alpha, (v) => o.alpha = v],
    };
  }
}

class GTweenableDouble with GTweenable {
  static GTweenable wrap(Object target) =>
      target is double ? GTweenableDouble(target) : null;

  double value;

  GTweenableDouble(double target) {
    this.value = this.target = target;
  }

  @override
  Map<String, List<Function>> getTweenableAccessors() => {
        'value': [() => value, (v) => value = v],
      };
}

class GTweenableInt with GTweenable {
  static GTweenable wrap(Object target) =>
      target is int ? GTweenableInt(target) : null;

  int value;

  GTweenableInt(int target) {
    this.value = this.target = target;
  }

  @override
  Map<String, List<Function>> getTweenableAccessors() => {
        'value': [
          () => value + .0,
          (double v) => value = v.round(),
        ],
      };
}

class GTweenableMap with GTweenable {
  static GTweenable wrap(Object target) =>
      target is Map<String, dynamic> ? GTweenableMap(target) : null;

  Map<String, dynamic> value;

  GTweenableMap(Map<String, dynamic> target) {
    value = this.target = target;
  }

  @override
  void setProperty(String prop, double val) {
    value[prop] = convertFromDouble(value[prop], val);
  }

  @override
  double getProperty(String prop) {
    /// add other conversions.
    return convertToDouble(value[prop]);
  }

  @override
  Map<String, List<Function>> getTweenableAccessors() => null;
}

class GTweenableList with GTweenable {
  static GTweenable wrap(Object target) {
    if (target is! List) return null;
    return GTweenableList(target);
  }

  List value;
  GTweenableList(List target) {
    value = this.target = target;
  }

  @override
  void setProperty(String prop, double val) {
    final index = int.tryParse(prop);
    value[index] = convertFromDouble(value[index], val);
  }

  @override
  double getProperty(String prop) {
    return convertToDouble(value[int.parse(prop)]);
  }

  @override
  Map<String, List<Function>> getTweenableAccessors() => null;
}

convertFromDouble(originalValue, double val) {
  if (originalValue is int) {
    return val.toInt();
  } else if (originalValue is String) {
    return '$val';
  } else {
    return val;
  }
}

double convertToDouble(val) {
  if (val is int) {
    return val + .0;
  } else if (val is String) {
    return double.tryParse(val);
  }
  return val;
}
