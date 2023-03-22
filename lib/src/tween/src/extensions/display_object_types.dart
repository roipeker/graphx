part of gtween;

/// An extension for the [GDisplayObject] class that provides a getter for
/// creating a [GTweenableDisplayObject] object.
extension GTweenDiplayObjectExt on GDisplayObject {
  /// Returns a [GTweenableDisplayObject] object created from the current
  /// [GDisplayObject].
  GTweenableDisplayObject get twn {
    return GTweenableDisplayObject(this);
  }

  /// Creates a [GTween] animation for the given properties and returns it.
  ///
  /// The [duration] parameter specifies the length of the tween animation, and
  /// the remaining parameters specify the properties to tween (in seconds
  /// `double` or frames `int`).
  ///
  /// The [ease] parameter can be used to specify an easing function to use for
  /// the tween animation. Use [GEase]
  ///
  /// The [delay] parameter can be used to delay the start of the tween
  /// animation (in seconds `double` or frames `int`).
  ///
  /// The [useFrames] parameter can be set to `true` to use frames instead of
  /// seconds for the tween animation.
  ///
  /// The [overwrite] parameter specifies the mode of tweening when the [GTween]
  /// animation already exists:
  /// 0 = no overwrite.
  /// 1 = overwrite all properties.
  ///
  /// The [onStart], [onStartParams], [onComplete], [onCompleteParams],
  /// [onUpdate], and [onUpdateParams] parameters can be used to specify
  /// functions to call at various stages of the tween animation.
  ///
  /// The [runBackwards] parameter can be set to `true` to run the tween
  /// animation backwards.
  ///
  /// The [startAt] parameter can be used to specify the initial values of the
  /// tween animation properties.
  GTween tween({
    required double duration,
    Object? x,
    Object? y,
    Object? scaleX,
    Object? scaleY,
    Object? scale,
    Object? rotation,
    Object? rotationX,
    Object? rotationY,
    Object? pivotX,
    Object? pivotY,
    Object? width,
    Object? height,
    Object? skewX,
    Object? skewY,
    Color? colorize,
    Object? alpha,
    EaseFunction? ease,
    double? delay,
    bool? useFrames,
    int overwrite = 1,
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
    final targetValues = {
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (scaleX != null) 'scaleX': scaleX,
      if (scaleY != null) 'scaleY': scaleY,
      if (scale != null) 'scale': scale,
      if (rotation != null) 'rotation': rotation,
      if (rotationX != null) 'rotationX': rotationX,
      if (rotationY != null) 'rotationY': rotationY,
      if (pivotX != null) 'pivotX': pivotX,
      if (pivotY != null) 'pivotY': pivotY,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (skewX != null) 'skewX': skewX,
      if (skewY != null) 'skewY': skewY,
      if (alpha != null) 'alpha': alpha,
      if (colorize != null) 'colorize': colorize,
    };

    return GTween.to(
      this,
      duration,
      targetValues,
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

  /// Sets properties and renders them immediately (using a tween animation with
  /// zero duration).
  ///
  /// The [delay] parameter can be used to delay the start of the "empty" tween
  /// animation that assigns the values.
  ///
  /// This method calls the `tween` method with the given properties and zero
  /// duration to apply the properties immediately.
  void setProps({
    Object? x,
    Object? y,
    Object? scaleX,
    Object? scaleY,
    Object? scale,
    Object? rotation,
    Object? pivotX,
    Object? pivotY,
    Object? width,
    Object? height,
    Object? skewX,
    Object? skewY,
    Object? rotationX,
    Object? rotationY,
    Object? alpha,
    Color? colorize,
    double delay = 0,
    bool? visible,
    bool immediateRender = true,
  }) {
    if (visible != null) {
      this.visible = visible;
    }
    tween(
      duration: 0,
      delay: delay,
      immediateRender: immediateRender,
      x: x,
      y: y,
      scaleX: scaleX,
      scaleY: scaleY,
      scale: scale,
      rotation: rotation,
      pivotX: pivotX,
      pivotY: pivotY,
      width: width,
      colorize: colorize,
      height: height,
      skewX: skewX,
      skewY: skewY,
      alpha: alpha,
      rotationX: rotationX,
      rotationY: rotationY,
    );
  }
}
