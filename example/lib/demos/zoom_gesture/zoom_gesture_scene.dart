import 'package:exampleGraphx/demos/pie_chart/scene.dart';
import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class ZoomGestureScene extends GSprite {
  late GSprite content;
  late GShape box;
  late GIcon pivotIcon;

  GPoint dragPoint = GPoint();
  GPoint grabPoint = GPoint();
  double grabRotation = 0.0;
  double grabScale = 1.0;

  @override
  void addedToStage() {
    super.addedToStage();
    stage!.maskBounds = true;
    stage!.color = Colors.grey.shade700;

    /// a reference icon to understand how the pivot is assign for the
    /// effect.
    pivotIcon = GIcon(Icons.add_circle_outline, Colors.black45, 20);
    pivotIcon.alignPivot(Alignment.center);

    content = GSprite();
    content.graphics
        .beginFill(Colors.grey.shade400)
        .lineStyle(3, Colors.white)
        .drawGRect(stage!.stageRect)
        .endFill();

    box = GShape();
    box.graphics.beginFill(Colors.blue).drawCircle(0, 0, 30).endFill();
    box.setPosition(100, 100);

    addChild(content);
    content.addChild(box);
    content.addChild(pivotIcon);

    resetContentInitialPosition();

    stage!.onMouseScroll.add(_onMouseScroll);
  }

  void _onMouseScroll(MouseInputData event) {
    dragPoint = event.stagePosition;
    adjustContentTransform();

    /// use mouse scroll wheel as incrementer for zoom.
    var _scale = content.scale;
    _scale += -event.scrollDelta.y * .001;
    setZoom(_scale);
  }

  void onScaleStart(ScaleStartDetails details) {
    trace('update!');

    /// If you need, you can detect 1 or more fingers here.
    /// for move vs zoom.
    if (details.pointerCount == 1) {}
    dragPoint = GPoint.fromNative(details.localFocalPoint);
    adjustContentTransform();
    grabRotation = content.rotation;
    grabScale = content.scale;
  }

  void adjustContentTransform() {
    final pivotPoint = content.globalToLocal(dragPoint);
    pivotIcon.x = content.pivotX = pivotPoint.x;
    pivotIcon.y = content.pivotY = pivotPoint.y;
    globalToLocal(dragPoint, grabPoint);
    content.setPosition(grabPoint.x, grabPoint.y);
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    final focalPoint = GPoint.fromNative(details.localFocalPoint);
    final deltaX = focalPoint.x - dragPoint.x;
    final deltaY = focalPoint.y - dragPoint.y;
    content.setPosition(grabPoint.x + deltaX, grabPoint.y + deltaY);

    /// use touch scale ratio for zoom.
    final _scale = details.scale * grabScale;
    setZoom(_scale);
    content.rotation = details.rotation + grabRotation;
  }

  void setZoom(double zoom) {
    content.scale = zoom.clamp(.5, 3.0);
  }

  void resetTransform() {
    content.pivotX = content.pivotY = content.rotation = 0;
    content.scale = 1;
    pivotIcon.setPosition(0, 0);
    resetContentInitialPosition();
    // content.transformationMatrix.identity();
    // pivotIcon.transformationMatrix.identity();
  }

  void resetContentInitialPosition() {
    content.scale = 0.8;
    content.alignPivot();
    content.centerInStage();
  }
}
