import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../utils.dart';

class HueScene extends GSprite {
  late GShape colorSelector;
  late GShape arrowSelector;
  GShape? lineSelector;
  Color? _selectedColor;

  double sw = 0.0, sh = 0.0;
  ByteData? colorsBytes;

  HueScene() {
    // config(usePointer: true, autoUpdateAndRender: true);
  }

  @override
  Future<void> addedToStage() async {
    var numHues = 20;
    var hvsList = List.generate(numHues, (index) {
      return HSVColor.fromAHSV(1, index / numHues * 360, 1, 1).toColor();
    });
    sw = stage!.stageWidth;
    sh = stage!.stageHeight;

    colorSelector = GShape();
    colorSelector.graphics
        .beginGradientFill(
          GradientType.linear,
          hvsList,
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        )
        .drawRoundRectComplex(0, 0, sw, sh, 0, 12, 0, 12)
        .endFill();

    const arrowSize = 5.0;
    arrowSelector = GShape();
    lineSelector = GShape();

    lineSelector!.graphics.beginFill(kColorWhite).drawRect(0, 0, sw, 10);
    lineSelector!.alignPivot();
    lineSelector!.x = sw / 2;

    /// create the arrow GShape first
    arrowSelector.graphics.beginFill(kColorBlack).drawPolygonFaces(
          0,
          0,
          arrowSize,
          3,
        );

    /// get the path.
    final arrowPath = arrowSelector.graphics.getPaths();

    /// clear the current graphics and apply the path with transforms.
    arrowSelector.graphics
        .clear()
        .beginFill(kColorWhite)
        .lineStyle()
        .drawPath(arrowPath, -arrowSize)
        .drawPath(arrowPath, sw + arrowSize, 0, GMatrix()..rotate(Math.PI));
    // lineSelector.alignPivot();
    // lineSelector.x = sw / 2;

    addChild(colorSelector);
    addChild(arrowSelector);
    addChild(lineSelector!);
    lineSelector!.alpha = 0;

    mouseChildren = false;
    lineSelector!.scaleX = 0;
    stage!.onMouseDown.add((input) {
      // lineSelector.y = sh / 2;
      GTween.killTweensOf(lineSelector);
      lineSelector!.height = 8;
      lineSelector!.tween(
        duration: .8,
        height: 2,
        scaleX: 1,
        alpha: 1,
        ease: GEase.easeOutExpo,
      );
      stage!.onMouseUp.addOnce((input) {
        lineSelector!.tween(
          duration: .8,
          scaleX: 0,
          height: 0,
        );
      });
      _updatePosition();
    });
    stage!.onMouseMove.add(_onMouseMove);

    var colorImage = colorSelector.createImageSync();
    var result = await colorImage.toByteData(format: ImageByteFormat.rawRgba);
    trace('result is:', result);

    /// get the image bytes from capturing the GShape snapshot.
    /// so we can get the colors from the bytes List.
    getImageBytes(colorSelector).then((value) {
      colorsBytes = value;
      trace(colorsBytes);
      updateColor();
    });
  }

  void _onMouseMove(MouseInputData input) {
    if (input.isPrimaryDown) {
      _updatePosition();
    }
  }

  void _updatePosition() {
    lineSelector!.y = arrowSelector.y = mouseY.clamp(0.0, sh - 1);
    updateColor();
  }

  void updateColor() {
    var bytes = colorsBytes;
    if (bytes == null) return;
    _selectedColor = getPixelColor(
      bytes,
      sw.toInt(),
      sh.toInt(),
      0,
      arrowSelector.y.toInt(),
    );

    /// emit the event to update the UI.
    pickerMPS.emit1<Color?>(ColorPickerEmitter.changeHue, _selectedColor);
  }
}
