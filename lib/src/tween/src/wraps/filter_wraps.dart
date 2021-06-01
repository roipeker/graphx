part of gtween;

class GTweenableBlur with GTweenable {
  static GTweenable? wrap(Object? target) {
    if (target is! GBlurFilter) return null;
    return GTweenableBlur(target);
  }

  late GBlurFilter value;

  GTweenableBlur(GBlurFilter target) {
    value = this.target = target;
  }

  @override
  Map<String, List<Function>> getTweenableAccessors() => {
        'blurX': [() => value.blurX, (v) => value.blurX = v],
        'blurY': [() => value.blurY, (v) => value.blurY = v],
      };

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
        ));
  }
}

class GTweenableDropShadowFilter with GTweenable {
  static GTweenable? wrap(Object? target) {
    if (target is! GDropShadowFilter) return null;
    return GTweenableDropShadowFilter(target);
  }

  late GDropShadowFilter value;

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

  @override
  Map<String, List<Function>> getTweenableAccessors() => {
        'blurX': [() => value.blurX, (v) => value.blurX = v],
        'blurY': [() => value.blurY, (v) => value.blurY = v],
        'angle': [() => value.angle, (v) => value.angle = v],
        'distance': [() => value.distance, (v) => value.distance = v],
        'color': [() => value.color, (v) => value.color = v],
      };

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
}

class GTweenableGlowFilter with GTweenable {
  static GTweenable? wrap(Object? target) {
    if (target is! GlowFilter) return null;
    return GTweenableGlowFilter(target);
  }

  late GlowFilter value;

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

  @override
  Map<String, List<Function>> getTweenableAccessors() => {
        'blurX': [() => value.blurX, (v) => value.blurX = v],
        'blurY': [() => value.blurY, (v) => value.blurY = v],
        'color': [() => value.color, (v) => value.color = v],
      };

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
        ));
  }
}
