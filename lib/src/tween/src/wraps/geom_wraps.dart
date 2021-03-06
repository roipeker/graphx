part of gtween;

class GTweenablePoint with GTweenable {
  static GTweenable? wrap(Object target) {
    if (target is! GPoint) return null;
    return GTweenablePoint(target);
  }

  late GPoint value;

  GTweenablePoint(GPoint target) {
    value = this.target = target;
  }

  @override
  Map<String, List<Function>> getTweenableAccessors() => {
        'x': [() => value.x, (v) => value.x = v],
        'y': [() => value.y, (v) => value.y = v],
      };

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
//          vars: vars,
          runBackwards: runBackwards,
          immediateRender: immediateRender,
          startAt: startAt,
        ));
  }
}

class GTweenableRect with GTweenable {
  static GTweenable? wrap(Object target) {
    if (target is! GRect) return null;
    return GTweenableRect(target);
  }

  late GRect value;

  GTweenableRect(GRect target) {
    value = this.target = target;
  }

  @override
  Map<String, List<Function>> getTweenableAccessors() => {
        'x': [() => value.x, (v) => value.x = v],
        'y': [() => value.y, (v) => value.y = v],
        'width': [() => value.width, (v) => value.width = v],
        'height': [() => value.height, (v) => value.height = v],
      };

  GTween tween(
      {required double duration,
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
      Map? startAt}) {
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
//          vars: vars,
          runBackwards: runBackwards,
          immediateRender: immediateRender,
          startAt: startAt,
        ));
  }
}

class GTweenableColor with GTweenable {
  static GTweenable? wrap(Object target) {
    if (target is! Color) return null;
    return GTweenableColor(target);
  }

  Color? value;
  late PropTween _propTween;
  Color? _targetColor;

  @override
  void setTweenProp(PropTween tweenProp) {
    _propTween = tweenProp;
    _propTween.c = 1.0; // set target value to 1.
  }

  GTweenableColor(Color target) {
    value = this.target = target;
  }

  @override
  void setProperty(Object? prop, double val) {
    value = Color.lerp(target as Color?, _targetColor, val);
  }

  @override
  double getProperty(Object prop) => 0.0; // start value, from 0-1

  GTween tween(Color color,
      {required double duration,
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
      Map? startAt}) {
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
//          vars: vars,
          runBackwards: runBackwards,
          immediateRender: immediateRender,
          startAt: startAt,
        ));
  }
}
