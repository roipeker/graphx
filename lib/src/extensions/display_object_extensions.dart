import '../../graphx.dart';

/// Extension methods to simplify the modification of [GDisplayObject]
/// properties.
extension DisplayObjectHelpers on GDisplayObject {
  /// Centers the object in the middle of the [Stage] if it's added to the
  /// stage.
  void centerInStage() {
    if (!inStage) {
      return;
    }
    setPosition(stage!.stageWidth / 2, stage!.stageHeight / 2);
  }

  /// Sets the specified properties to the object (using a tween animation with
  /// zero duration).
  /// The [delay] parameter can be used to delay the start of the "empty" tween
  /// animation that assigns the values.
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
    Object? alpha,
    double delay = 0,
  }) {
    tween(
      duration: 0,
      delay: delay,
      x: x,
      y: y,
      scaleX: scaleX,
      scaleY: scaleY,
      scale: scale,
      rotation: rotation,
      pivotX: pivotX,
      pivotY: pivotY,
      width: width,
      height: height,
      skewX: skewX,
      skewY: skewY,
      alpha: alpha,
    );
  }
}
