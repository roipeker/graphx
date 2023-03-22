part of gtween;

/// (Internal usage)
///
/// A class that represents the variables of a [GTween] animation.
///
class GVars {
  /// A key to refer to the current tween object when passing parameters to the
  /// callbacks.
  static const String selfTweenKey = '{self}';

  /// The easing function of the animation.
  EaseFunction? ease;

  /// The delay before starting the animation.
  double? delay;

  /// Determines whether to use frames instead of time for the animation.
  bool? useFrames;

  /// Determines how to handle overwriting of a tween.
  int? overwrite;

  /// The function to call when the animation starts.
  Function? onStart;

  /// The parameters to pass to the [onStart] function.
  CallbackParams? onStartParams;

  /// The function to call when the animation completes.
  Function? onComplete;

  /// The parameters to pass to the [onComplete] function.
  CallbackParams? onCompleteParams;

  /// The function to call when the animation updates.
  Function? onUpdate;

  /// The parameters to pass to the [onUpdate] function.
  CallbackParams? onUpdateParams;

  /// Determines whether to run the animation backwards.
  bool? runBackwards;

  /// Determines whether to immediately render the object at the beginning of
  /// the animation.
  bool? immediateRender;

  /// The variables to start the animation at.
  Map? startAt;

  /// Creates a new instance of [GVars].
  ///
  /// [ease], [delay], [useFrames], [overwrite], [onStart], [onComplete],
  /// [onUpdate], [onStartParams], [onCompleteParams], [onUpdateParams],
  /// [runBackwards], [immediateRender], and [startAt] can be set on
  /// instantiation.
  GVars({
    this.ease,
    this.delay,
    this.useFrames,
    this.overwrite,
    this.onStart,
    this.onComplete,
    this.onUpdate,
    Object? onStartParams,
    Object? onCompleteParams,
    Object? onUpdateParams,
    this.runBackwards,
    this.immediateRender,
    this.startAt,
  }) {
    // For easy of use, you can send any Object to be parsed as function
    // arguments.
    this.onStartParams = CallbackParams.parse(onStartParams);
    this.onCompleteParams = CallbackParams.parse(onCompleteParams);
    this.onUpdateParams = CallbackParams.parse(onUpdateParams);
  }

  /// Sets default values for variables not set on instantiation.
  void defaults() {
    ease ??= GTween.defaultEase;
    immediateRender ??= false;
    useFrames ??= false;
    runBackwards ??= false;
  }

  /// Sets the callback parameters of a [GTween] instance based on the
  /// [CallbackParams] object.
  ///
  /// [twn] - The [GTween] instance to set the callback parameters of.
  ///
  /// [params] - The [CallbackParams] object to use for setting the callback
  /// parameters. If any of the callback parameters have named or positional
  /// arguments with the value "{self}", it will replace it with the current
  /// tween instance to create self-reference.
  void _setCallbackParams(GTween twn, CallbackParams params) {
    final named = params.named;
    final positional = params.positional;
    if (named != null) {
      if (named.containsValue(selfTweenKey)) {
        for (var e in named.entries) {
          if (e.value == selfTweenKey) {
            named[e.key] = twn;
          }
        }
      }
    }
    if (positional != null) {
      if (positional.contains(selfTweenKey)) {
        params.positional = positional.map((e) {
          if (e == selfTweenKey) {
            return twn;
          }
          return e;
        }).toList();
      }
    }
  }

  /// Sets the tween of a [GTween] instance based on the variables of this
  /// instance.
  void _setTween(GTween gTween) {
    if (onStartParams != null) {
      _setCallbackParams(gTween, onStartParams!);
    }
    if (onCompleteParams != null) {
      _setCallbackParams(gTween, onCompleteParams!);
    }
    if (onUpdateParams != null) {
      _setCallbackParams(gTween, onUpdateParams!);
    }
//    onStartParams?._setTween(gTween);
//    onCompleteParams?._setTween(gTween);
//    onUpdateParams?._setTween(gTween);
  }
}
