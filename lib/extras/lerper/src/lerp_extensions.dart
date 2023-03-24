part of lerper;

extension DoubleTween on double {
  double sinRate() => LerpTools.sin(this);

  double cosRate() => LerpTools.cos(this);

  double revert() => LerpTools.revert(clamped(0, 1));

  double sineIn() => EasingTools.sineIn(this);

  double sineOut() => EasingTools.sineOut(this);

  double sineInOut() => EasingTools.sineInOut(this);

  double sineOutIn() => EasingTools.sineOutIn(this);

  double quadIn() => EasingTools.quadIn(this);

  double quadOut() => EasingTools.quadOut(this);

  double quadInOut() => EasingTools.quadInOut(this);

  double quadOutIn() => EasingTools.quadOutIn(this);

  double cubicIn() => EasingTools.cubicIn(this);

  double cubicOut() => EasingTools.cubicOut(this);

  double cubicInOut() => EasingTools.cubicInOut(this);

  double cubicOutIn() => EasingTools.cubicOutIn(this);

  double quintIn() => EasingTools.quintIn(this);

  double quintOut() => EasingTools.quintOut(this);

  double quintInOut() => EasingTools.quintInOut(this);

  double quintOutIn() => EasingTools.quintOutIn(this);

  double expoIn() => EasingTools.expoIn(this);

  double expoOut() => EasingTools.expoOut(this);

  double expoInOut() => EasingTools.expoInOut(this);

  double expoOutIn() => EasingTools.expoOutIn(this);

  double circIn() => EasingTools.circIn(this);

  double circOut() => EasingTools.circOut(this);

  double circInOut() => EasingTools.circInOut(this);

  double circOutIn() => EasingTools.circOutIn(this);

  double bounceIn() => EasingTools.bounceIn(this);

  double bounceOut() => EasingTools.bounceOut(this);

  double bounceInOut() => EasingTools.bounceInOut(this);

  double bounceOutIn() => EasingTools.bounceOutIn(this);

  double backIn() => EasingTools.backIn(this);

  double backOut() => EasingTools.backOut(this);

  double backInOut() => EasingTools.backInOut(this);

  double backOutIn() => EasingTools.backOutIn(this);

  double elasticIn([
    double period = EasingTools.defaultPeriod,
    double amplitude = EasingTools.defaultAmplitude,
  ]) =>
      EasingTools.elasticIn(
        this,
        period,
        amplitude,
      );

  double elasticOut([
    double period = EasingTools.defaultPeriod,
    double amplitude = EasingTools.defaultAmplitude,
  ]) {
    return EasingTools.elasticOut(
        this,
        period,
        amplitude,
      );
  }

  double elasticInOut([
    double period = EasingTools.defaultPeriod,
    double amplitude = EasingTools.defaultAmplitude,
  ]) {
    return EasingTools.elasticInOut(
      this,
      period,
      amplitude,
    );
  }

  double elasticOutIn([
    double period = EasingTools.defaultPeriod,
    double amplitude = EasingTools.defaultAmplitude,
  ]) {
    return EasingTools.elasticOutIn(
        this,
        period,
        amplitude,
      );
  }

  double warpIn() {
    return EasingTools.warpIn(this);
  }

  double warpOut() => EasingTools.warpOut(this);

  double warpInOut() => EasingTools.warpInOut(this);

  double warpOutIn() => EasingTools.warpOutIn(this);

  double shake([
    double center = 0,
    double Function()? randomCallback,
  ]) =>
      LerpTools.shake(this, center, randomCallback);

  double lerp(num from, num to) {
    return LerpTools.lerp(this, from, to);
  }

  double invLerp(num from, num to) => LerpTools.inverseLerp(
        this,
        from,
        to,
      );

  /// To wrap a normalized value [lerp()] to a range.
  /// Useful to keep a "loop" during a time rate.
  /// For example...
  /// ```dart
  ///   var frame = 0;
  ///   onTick(){
  ///     // it will wait 20 frames, then run til frame 80.
  ///     // and wrap back (modulo) to 0, and wait 20 frames again...
  ///     var t = ++frame.wrapLerp(80, 20);
  ///     print(t);
  ///   }
  ///
  double wrapLerp(num end, [num start = 0, bool clamped = true]) {
    var value = LerpTools.inverseLerp(this % end, start, end);
    if (clamped) {
      value = value.clamped(0, 1);
    }
    return value;
  }

  // used to set bounds to wrapped normalized values.
  // for example, set a delay (start) and duration (end).
  // based on a rate (wrappedRate)  previously
  // wrapped by [wrapLerp()].
  // use [validLerp()] to check if the result is in valid range
  // (0-1).
  @pragma('vm:prefer-inline')
  double invWrapLerp(num wrappedRate, num start, num end, [bool clamp = true]) {
    final result = invLerp(start / wrappedRate, end / wrappedRate);
    return clamp ? result.clamped(0, 1) : result;
  }

  /// To repeat x [times] a normalized value [lerp()].
  /// Can be chained with [reverse()] and [yoyo()].
  double repeatLerp(double times) {
    final invRepeat = 1 / times;
    return (this % invRepeat).invLerp(0, invRepeat);
  }

  @pragma('vm:prefer-inline')
  double clamped(double min, double max) => LerpTools.clamp(this, min, max);

  // to use in if() statement
  @pragma('vm:prefer-inline')
  bool validLerp() => this >= 0 && this <= 1;

  @pragma('vm:prefer-inline')
  double mixEase(EaseFun ease1, EaseFun ease2, [double strength = 0.5]) {
    return LerpTools.mixEasing(this, ease1, ease2, strength);
  }

  @pragma('vm:prefer-inline')
  double yoyo([EaseFun ease = EasingTools.linear]) =>
      LerpTools.yoyo(this, ease);

  @pragma('vm:prefer-inline')
  double reverse([EaseFun ease = EasingTools.linear]) =>
      LerpTools.reverse(this, ease);

  @pragma('vm:prefer-inline')
  double connectEasing(
    EaseFun easing1,
    EaseFun easing2, [
    double switchTime = 0.5,
    double switchValue = 0.5,
  ]) {
    return LerpTools.connectEasing(
        this, easing1, easing2, switchTime, switchValue);
  }

  @pragma('vm:prefer-inline')
  double crossfadeEasing(
    EaseFun easing1,
    EaseFun easing2,
    EaseFun easing2StrengthEasing, [
    double easing2StrengthStart = 0,
    double easing2StrengthEnd = 1,
  ]) =>
      LerpTools.crossfadeEasing(
        this,
        easing1,
        easing2,
        easing2StrengthEasing,
        easing2StrengthStart,
        easing2StrengthEnd,
      );

  // quadratic
  @pragma('vm:prefer-inline')
  double bezier2(double from, double control, double to) =>
      LerpTools.bezier2(this, from, control, to);

  /// cubic easing.
  @pragma('vm:prefer-inline')
  double cubic(
    double from,
    double control1,
    double control2,
    double to, [
    double resolution = .001,
  ]) =>
      LerpTools.cubic(this, from, control1, control2, to, resolution);

  /// cubic
  @pragma('vm:prefer-inline')
  double bezier3(
    double from,
    double control1,
    double control2,
    double to,
  ) =>
      LerpTools.bezier3(this, from, control1, control2, to);

  double bezier(Iterable<double> points) => LerpTools.bezier(this, points);

  double bspline(Iterable<double> points) =>
      LerpTools.uniformQuadBSpline(this, points);

  double polyline(Iterable<double> points) =>
      LerpTools.polyline(this, points.toList(growable: false));
}

/// Extension providing easing functions and math utilities for [int] values.
extension EaseInt on int {
  /// Returns a linearly interpolated [double] between [from] and [to] for this
  /// [int] value.
  double lerp(num from, num to) {
    return LerpTools.lerp(
      toDouble(),
      from.toDouble(),
      to.toDouble(),
    );
  }

  /// Returns a wrapped linearly interpolated [double] between [start] and [end]
  /// for this [int] value. The value is wrapped within the range `[0, end)`.
  double wrapLerp(num end, [num start = 0]) {
    return LerpTools.inverseLerp(this % end, start, end);
  }

  /// Returns a random value based on this [int] value as a seed, with a
  /// [center] value and optional [randomCallback] function.
  double shake([
    double center = 0,
    double Function()? randomCallback,
  ]) {
    return LerpTools.shake(toDouble(), center, randomCallback);
  }

  /// Returns the inverse of the linearly interpolated value between [from] and
  /// [to] for this [int] value.
  double lerpInverse(num from, num to) {
    return LerpTools.inverseLerp(
      toDouble(),
      from.toDouble(),
      to.toDouble(),
    );
  }
}
