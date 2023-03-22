part of gtween;

//// ---------------------------------------------------------------------------

/// A class that wraps a [Color] object and makes it animatable with [GTween].
///
/// To use this class, create an instance with a [Color] object and call the
/// `tween()` method to create a [GTween] animation.
class GTweenableColor with GTweenable {
  /// This property holds the current [Color] value being tweened by [GTween].
  Color? value;

  /// The property tween object used by [GTween].
  late PropTween _propTween;

  /// The target [Color] to tween towards.
  Color? _targetColor;

  /// Creates a new instance of [GTweenableColor] with the given [target] value.
  GTweenableColor(Color target) {
    value = this.target = target;
  }

  /// Overrides the method in [GTweenable].
  /// It returns the start value of the property being tweened, from 0-1.
  @override
  double getProperty(Object property) {
    // start value, from 0-1
    return 0.0;
  }

  /// Sets the current value property of [GTweenableColor] by lerping between
  /// the target [Color] and _targetColor using the given [targetValue].
  @override
  void setProperty(Object? property, double targetValue) {
    value = Color.lerp(target as Color?, _targetColor, targetValue);
  }

  /// Sets the property tween object _propTween used by [GTween], and sets the
  /// target value to 1.
  @override
  void setTweenProp(PropTween tweenProp) {
    _propTween = tweenProp;
    // set target value to 1.
    _propTween.c = 1.0;
  }

  /// Creates a [GTween] animation for this object.
  GTween tween(
    Color color, {
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
    _targetColor = color;
    return GTween.to(
      this,
      duration,
      {'value': 1},
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

  /// Wraps the given object [target] as a [GTweenableColor] if it is a
  /// [Color], otherwise returns `null`.
  static GTweenable? wrap(Object target) {
    if (target is! Color) {
      return null;
    }
    return GTweenableColor(target);
  }
}

/// A class that wraps a [GPoint] object and makes it animatable with [GTween].
///
/// To use this class, create an instance with a [GPoint] object and call the
/// `tween()` method to create a [GTween] animation.
class GTweenablePoint with GTweenable {
  /// This property holds the current [GPoint] value being tweened by [GTween].
  late GPoint value;

  /// Creates a new instance of [GTweenablePoint] with the given [target] value.
  GTweenablePoint(GPoint target) {
    value = this.target = target;
  }

  /// Returns a map of properties that can be animated, in this case 'x' and
  /// 'y'. Each property maps to a list of two functions: one to get the current
  /// value of the property, and another to set the value of the property.
  @override
  Map<String, List<Function>> getTweenableAccessors() {
    return {
      'x': [() => value.x, (v) => value.x = v],
      'y': [() => value.y, (v) => value.y = v],
    };
  }

  /// Creates a [GTween] animation for this object.
  ///
  /// The animation can target the 'x' and 'y' properties. You can pass the
  /// values for the properties either as separate x and y arguments, or as
  /// a single [GPoint] object in the to argument. You can also specify the
  /// duration, easing function, delay, and other parameters for the animation.
  ///
  /// If you pass values for both [x] and [y] arguments and the [to] argument,
  /// an exception will be thrown. Choose one method to set the values.
  ///
  /// Returns the created [GTween] object.
  GTween tween({
    required double duration,
    Object? x,
    Object? y,
    GPoint? to,
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
    if ((x != null || y != null) && to != null) {
      throw '''
GTween Can't use 'x, y' AND 'to' arguments for GxPoint tween. Choose one''';
    }
    x = to?.x ?? x;
    y = to?.y ?? y;
    final targetMap = {
      if (x != null) 'x': x,
      if (y != null) 'y': y,
    };
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

  /// Wraps the given object [target] as a [GTweenablePoint] if it is a
  /// [GPoint], otherwise returns `null`.
  static GTweenable? wrap(Object target) {
    if (target is! GPoint) {
      return null;
    }
    return GTweenablePoint(target);
  }
}

//// ---------------------------------------------------------------------------

/// A class that wraps a [GRect] object and makes it animatable with [GTween].
///
/// To use this class, create an instance with a [GRect] object and call the
/// `tween()` method to create a [GTween] animation.
class GTweenableRect with GTweenable {
  /// This property holds the current [GRect] value being tweened by [GTween].
  late GRect value;

  /// Creates a new instance of [GTweenableRect] with the given [target] value.
  GTweenableRect(GRect target) {
    value = this.target = target;
  }

  /// Returns a map of properties that can be animated, in this case 'x', 'y',
  /// 'width' and 'height'. Each property maps to a list of two functions: one
  /// to get the current value of the property, and another to set the value of
  /// the property.
  @override
  Map<String, List<Function>> getTweenableAccessors() {
    return {
      'x': [() => value.x, (v) => value.x = v],
      'y': [() => value.y, (v) => value.y = v],
      'width': [() => value.width, (v) => value.width = v],
      'height': [() => value.height, (v) => value.height = v],
    };
  }

  /// Creates a [GTween] animation for this object.
  GTween tween({
    required double duration,
    Object? x,
    Object? y,
    Object? width,
    Object? height,
    GRect? to,
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
    if ((x != null || y != null || width != null || height != null) &&
        to != null) {
      throw "GTween Can't use 'x, y, width, height' AND 'to' arguments to "
          "tween a [GxRect]. Choose one";
    }
    x = to?.x ?? x;
    y = to?.y ?? y;
    width = to?.width ?? width;
    height = to?.height ?? height;

    final targetMap = {
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
    };

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

  /// Wraps the given object [target] as a [GTweenableRect] if it is a
  /// [GRect], otherwise returns `null`.
  static GTweenable? wrap(Object target) {
    if (target is! GRect) {
      return null;
    }
    return GTweenableRect(target);
  }
}
