part of gtween;

/// A GTweenable class for [GBlurFilter] objects. The properties of the
/// [GBlurFilter] that can be tweened are blurX and blurY.
///
class GTweenableBlur with GTweenable {
  /// The target value of the [GBlurFilter] instance being tweened.
  late GBlurFilter value;

  /// Creates a new instance of [GTweenableBlur] with the given [target] value.
  GTweenableBlur(GBlurFilter target) {
    value = this.target = target;
  }

  /// Returns a Map with the accessors for the [GTweenableBlur] target.
  @override
  Map<String, List<Function>> getTweenableAccessors() {
    return {
      'blurX': [() => value.blurX, (v) => value.blurX = v],
      'blurY': [() => value.blurY, (v) => value.blurY = v],
    };
  }

  /// Creates a new [GTween] instance to tween the properties of
  /// [GTweenableBlur].
  GTween tween({
    required double duration,
    Object? blurX,
    Object? blurY,
    EaseFunction? ease,
    double? delay,
    bool? useFrames,
    int overwrite = 1,
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
    final targetMap = {
      if (blurX != null) 'blurX': blurX,
      if (blurY != null) 'blurY': blurY,
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

  /// Wraps the given object [target] as a [GTweenableBlur] if it is a
  /// [GBlurFilter], otherwise returns `null`.
  static GTweenable? wrap(Object? target) {
    if (target is! GBlurFilter) {
      return null;
    }
    return GTweenableBlur(target);
  }
}

//// ---------------------------------------------------------------------------

/// A GTweenable class for [GDropShadowFilter] objects. The properties of the
/// [GDropShadowFilter] that can be tweened are blurX, blurY, angle, distance
/// and color.
///
class GTweenableDropShadowFilter with GTweenable {
  /// The target value of the [GDropShadowFilter] instance being tweened.
  late GDropShadowFilter value;

  /// Creates a new instance of [GTweenableDropShadowFilter] with the given
  /// [target] value.
  GTweenableDropShadowFilter(GDropShadowFilter target) {
    value = this.target = target;
    _addLerp(
      'color',
      GTweenLerpColor(
        setProp: (value) => target.color = value,
        getProp: () => target.color,
      ),
    );
  }

  /// Returns a Map with the accessors for the [GTweenableDropShadowFilter]
  /// target.
  @override
  Map<String, List<Function>> getTweenableAccessors() {
    return {
      'blurX': [() => value.blurX, (v) => value.blurX = v],
      'blurY': [() => value.blurY, (v) => value.blurY = v],
      'angle': [() => value.angle, (v) => value.angle = v],
      'distance': [() => value.distance, (v) => value.distance = v],
      'color': [() => value.color, (v) => value.color = v],
    };
  }

  /// Creates a tween of the GDropShadowFilter properties.
  ///
  /// [duration] is the duration of the tween.
  ///
  /// [blurX] is the horizontal blur amount.
  ///
  /// [blurY] is the vertical blur amount.
  ///
  /// [angle] is the angle of the drop shadow.
  ///
  /// [distance] is the distance of the drop shadow.
  ///
  /// [color] is the color of the drop shadow.
  ///
  /// [ease] is the easing function for the tween.
  ///
  /// [delay] is the delay before starting the tween.
  ///
  /// [useFrames] specifies whether to use frames for the tween.
  ///
  /// [overwrite] specifies the behavior when overwriting an existing tween.
  ///
  /// [onStart] is a callback function that is called when the tween starts.
  ///
  /// [onStartParams] are the parameters for the onStart callback function.
  ///
  /// [onComplete] is a callback function that is called when the tween
  /// completes.
  ///
  /// [onCompleteParams] are the parameters for the onComplete callback
  /// function.
  ///
  /// [onUpdate] is a callback function that is called when the tween updates.
  ///
  /// [onUpdateParams] are the parameters for the onUpdate callback function.
  ///
  /// [runBackwards] specifies whether to run the tween backwards.
  ///
  /// [immediateRender] specifies whether to immediately render the tween.
  ///
  /// [startAt] is a map of properties to set before starting the tween.
  GTween tween({
    required double duration,
    Object? blurX,
    Object? blurY,
    Object? angle,
    Object? distance,
    Color? color,
    EaseFunction? ease,
    double? delay,
    bool? useFrames,
    int overwrite = 1,
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
    final targetMap = {
      if (blurX != null) 'blurX': blurX,
      if (blurY != null) 'blurY': blurY,
      if (angle != null) 'angle': angle,
      if (distance != null) 'distance': distance,
      if (color != null) 'color': color,
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
        ));
  }

  /// Wraps the given object [target] as a [GTweenableDropShadowFilter] if it is
  /// a [GDropShadowFilter], otherwise returns `null`.
  static GTweenable? wrap(Object? target) {
    if (target is! GDropShadowFilter) {
      return null;
    }
    return GTweenableDropShadowFilter(target);
  }
}

//// ---------------------------------------------------------------------------

/// A [GTweenable] class for [GlowFilter] objects. The properties of the
/// [GlowFilter] that can be tweened are color, blurX, blurY.
///
class GTweenableGlowFilter with GTweenable {
  /// The target value of the [GlowFilter] instance being tweened.
  late GlowFilter value;

  /// Creates a new instance of [GTweenableGlowFilter] with the given [target]
  /// value.
  GTweenableGlowFilter(GlowFilter target) {
    value = this.target = target;
    _addLerp(
      'color',
      GTweenLerpColor(
        setProp: (value) => target.color = value,
        getProp: () => target.color,
      ),
    );
  }

  /// Returns a Map with the accessors for the [GTweenableBlur] target.
  @override
  Map<String, List<Function>> getTweenableAccessors() {
    return {
      'blurX': [() => value.blurX, (v) => value.blurX = v],
      'blurY': [() => value.blurY, (v) => value.blurY = v],
      'color': [() => value.color, (v) => value.color = v],
    };
  }

  /// Creates a new [GTween] instance to tween the properties of
  /// [GTweenableGlowFilter].
  GTween tween({
    required double duration,
    Object? blurX,
    Object? blurY,
    Color? color,
    EaseFunction? ease,
    double? delay,
    bool? useFrames,
    int overwrite = 1,
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
    final targetMap = {
      if (blurX != null) 'blurX': blurX,
      if (blurY != null) 'blurY': blurY,
      if (color != null) 'color': color,
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

  /// Wraps the given object [target] as a [GTweenableGlowFilter] if it is a
  /// [GlowFilter], otherwise returns `null`.
  static GTweenable? wrap(Object? target) {
    if (target is! GlowFilter) {
      return null;
    }
    return GTweenableGlowFilter(target);
  }
}
