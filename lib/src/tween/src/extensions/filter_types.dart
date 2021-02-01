part of gtween;

extension GTweenBlurFilterExt on GBlurFilter {
  GTweenableBlur get twn => GTweenableBlur(this);
  GTween tween({
    @required double duration,
    Object blurX,
    Object blurY,
    EaseFunction ease,
    double delay,
    bool useFrames,
    int overwrite = 1,
    VoidCallback onStart,
    Object onStartParams,
    VoidCallback onComplete,
    Object onCompleteParams,
    VoidCallback onUpdate,
    Object onUpdateParams,
    bool runBackwards,
    bool immediateRender,
    Map startAt,
  }) =>
      twn.tween(
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

extension GTweenDropShadowFilterExt on GDropShadowFilter {
  GTweenableDropShadowFilter get twn => GTweenableDropShadowFilter(this);
  GTween tween({
    @required double duration,
    Object blurX,
    Object blurY,
    Object angle,
    Object distance,
    Color color,
    EaseFunction ease,
    double delay,
    bool useFrames,
    int overwrite = 1,
    VoidCallback onStart,
    Object onStartParams,
    VoidCallback onComplete,
    Object onCompleteParams,
    VoidCallback onUpdate,
    Object onUpdateParams,
    bool runBackwards,
    bool immediateRender,
    Map startAt,
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

extension GTweenGlowFilterExt on GlowFilter {
  GTweenableGlowFilter get twn => GTweenableGlowFilter(this);
  GTween tween({
    @required double duration,
    Object blurX,
    Object blurY,
    Color color,
    EaseFunction ease,
    double delay,
    bool useFrames,
    int overwrite = 1,
    VoidCallback onStart,
    Object onStartParams,
    VoidCallback onComplete,
    Object onCompleteParams,
    VoidCallback onUpdate,
    Object onUpdateParams,
    bool runBackwards,
    bool immediateRender,
    Map startAt,
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
