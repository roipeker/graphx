part of gtween;

/// An extension of [GBlurFilter] to create tween animations for the blur
/// filter.
extension GTweenBlurFilterExt on GBlurFilter {

  /// Returns a [GTweenableBlur] instance of the blur filter.
  GTweenableBlur get twn {
    return GTweenableBlur(this);
  }

  /// Creates a tween animation for the blur filter properties.
  ///
  /// The [duration] parameter specifies the duration of the animation. The
  /// [blurX] and [blurY] parameters specify the end values for the X and Y blur
  /// amounts, respectively. The [ease] parameter specifies the easing function
  /// to be used for the animation.
  ///
  /// Returns a [GTween] instance of the animation.
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
    return twn.tween(
      duration: duration,
      blurX: blurX,
      blurY: blurY,
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
    );
  }
}

/// Extension on [GDropShadowFilter] providing a getter for
/// [GTweenableDropShadowFilter] and a tween method to tween the properties of
/// the drop shadow filter.
extension GTweenDropShadowFilterExt on GDropShadowFilter {
  /// Getter for [GTweenableDropShadowFilter] on the drop shadow filter.
  GTweenableDropShadowFilter get twn {
    return GTweenableDropShadowFilter(this);
  }

  /// Tween the properties of the drop shadow filter.
  ///
  /// [duration] is the duration of the tween animation in seconds.
  ///
  /// [blurX] is the horizontal blur amount of the drop shadow.
  ///
  /// [blurY] is the vertical blur amount of the drop shadow.
  ///
  /// [angle] is the angle of the drop shadow in radians.
  ///
  /// [distance] is the distance of the drop shadow in pixels.
  ///
  /// [color] is the color of the drop shadow.
  ///
  /// [ease] is the easing function to use for the tween animation.
  ///
  /// [delay] is the delay before starting the tween animation in seconds.
  ///
  /// [useFrames] determines whether to use frames instead of seconds for the
  /// duration and delay.
  ///
  /// [overwrite] determines the behavior when attempting to tween a property
  /// that is already being tweened.
  ///
  /// [onStart] is a callback function to call when the tween animation starts.
  ///
  /// [onStartParams] are the parameters to pass to the [onStart] callback
  /// function.
  ///
  /// [onComplete] is a callback function to call when the tween animation
  /// completes.
  ///
  /// [onCompleteParams] are the parameters to pass to the [onComplete] callback
  /// function.
  ///
  /// [onUpdate] is a callback function to call every time the tween animation
  /// updates.
  ///
  /// [onUpdateParams] are the parameters to pass to the [onUpdate] callback
  /// function.
  ///
  /// [runBackwards] determines whether to run the tween animation backwards.
  ///
  /// [immediateRender] determines whether to immediately render the tweened
  /// properties.
  ///
  /// [startAt] is a map of initial values to set on the properties before
  /// starting the tween animation.
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
    return twn.tween(
      duration: duration,
      blurX: blurX,
      blurY: blurY,
      angle: angle,
      distance: distance,
      color: color,
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
    );
  }
}

/// Extension on [GlowFilter] providing a getter for [GTweenableGlowFilter]
/// and a tween method to tween the properties of the glow filter.
extension GTweenGlowFilterExt on GlowFilter {

  /// Returns a [GTweenableGlowFilter] that can be animated with GTween.
  GTweenableGlowFilter get twn {
    return GTweenableGlowFilter(this);
  }

  /// Animates the properties of this [GlowFilter] over a given [duration] using
  /// [GTween].
  ///
  /// The [blurX], [blurY], and [color] properties can be animated. You can use
  /// the [ease], [delay], and [useFrames] parameters to control the ease
  /// function, delay, and time units of the animation. The [overwrite]
  /// parameter determines how overlapping animations are handled. You can
  /// specify callbacks for when the animation starts, updates, and completes
  /// with the [onStart], [onUpdate], and [onComplete] parameters, respectively.
  /// You can also pass parameters to those callbacks using the [onStartParams],
  /// [onUpdateParams], and [onCompleteParams] parameters. The [runBackwards]
  /// parameter specifies whether the animation should start in reverse. You can
  /// also specify a map of values to use as the initial state of the animation
  /// with the [startAt] parameter.
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
    return twn.tween(
      duration: duration,
      blurX: blurX,
      blurY: blurY,
      color: color,
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
    );
  }
}