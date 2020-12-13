part of gtween;

extension GTweenDiplayObjectExt on DisplayObject {
  GTweenableDisplayObject get twn => GTweenableDisplayObject(this);

  GTween tween({
    @required double duration,
    Object x,
    Object y,
    Object scaleX,
    Object scaleY,
    Object scale,
    Object rotation,
    Object rotationX,
    Object rotationY,
    Object pivotX,
    Object pivotY,
    Object width,
    Object height,
    Object skewX,
    Object skewY,
    Color colorize,
    Object alpha,
    EaseFunction ease,
    double delay,
    bool useFrames,
    int overwrite=1,
    Function onStart,
    Object onStartParams,
    Function onComplete,
    Object onCompleteParams,
    Function onUpdate,
    Object onUpdateParams,
    bool runBackwards,
    bool immediateRender,
    Map startAt,
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
}
