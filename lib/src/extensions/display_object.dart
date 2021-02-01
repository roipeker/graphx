import '../../graphx.dart';

extension DisplayObjectHelpers on GDisplayObject {
  void centerInStage() {
    if (!inStage) return;
    setPosition(stage.stageWidth / 2, stage.stageHeight / 2);
  }

  void setProps({
    Object x,
    Object y,
    Object scaleX,
    Object scaleY,
    Object scale,
    Object rotation,
    Object pivotX,
    Object pivotY,
    Object width,
    Object height,
    Object skewX,
    Object skewY,
    Object alpha,
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
