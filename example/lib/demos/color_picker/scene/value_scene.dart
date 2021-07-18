import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import '../utils.dart';

class ValueScene extends GSprite {
  late GShape bgColor;
  late GShape bgBrightness;
  late GShape bgValue;
  late GSprite colorsContainer;
  ByteData? colorsBytes;
  late GShape selector;
  Color? _selectedColor;
  double sw = 0.0, sh = 0.0;

  ValueScene();

  @override
  void addedToStage() {
    sw = stage!.stageWidth;
    sh = stage!.stageHeight;

    bgColor = GShape();
    bgColor.graphics
        .beginFill(const Color(0xff0000ff))
        .drawRect(0, 0, sw, sh)
        .endFill();

    bgBrightness = GShape();
    drawGradient(bgBrightness.graphics, color: kColorWhite, isHorizontal: true);

    bgValue = GShape();
    drawGradient(bgValue.graphics, color: kColorBlack, isHorizontal: false);

    final radius = 8.0;
    selector = GShape();
    selector.graphics
        .lineStyle(2, kColorWhite)
        .drawCircle(0, 0, radius)
        .endFill()
        .lineStyle(2, kColorBlack)
        .drawCircle(0, 0, radius - 2)
        .endFill();
    selector.alpha = .8;

    colorsContainer = GSprite();
    colorsContainer.addChild(bgColor);
    colorsContainer.addChild(bgBrightness);
    colorsContainer.addChild(bgValue);

    addChild(colorsContainer);
    addChild(selector);

    mouseChildren = false;
    stage!.onMouseDown.add((e) {
      _updateColor();
      selector.tween(duration: .4, scale: 1.5);
      GMouse.hide();
      stage!.onMouseUp.addOnce((e) {
        GMouse.show();
        selector.tween(duration: .3, scale: 1);
      });
    });
    stage!.onMouseMove.add(_handleMouseMove);
    pickerMPS.on(ColorPickerEmitter.changeHue, handleChangeHue);
  }

  void _handleMouseMove(MouseInputData input) {
    if (input.isPrimaryDown) {
      _updateColor();
    }
  }

  void _updateColor() {
    selector.x = mouseX.clamp(0.0, sw - 1);
    selector.y = mouseY.clamp(0.0, sh - 1);
    updateColor();
  }

  void drawGradient(Graphics graphics,
      {required Color color, required bool isHorizontal}) {
    var from = isHorizontal ? Alignment.centerLeft : Alignment.bottomCenter;
    var to = isHorizontal ? Alignment.centerRight : Alignment.topCenter;
    graphics
        .beginGradientFill(
            GradientType.linear, [color.withOpacity(1), color.withOpacity(0)],
            begin: from, end: to)
        .drawRect(0, 0, sw, sh)
        .endFill();
  }

  Future<void> handleChangeHue(Color hueColor) async {
    bgColor.graphics
        .clear()
        .beginFill(hueColor)
        .drawRect(0, 0, sw, sh)
        .endFill();

    /// to avoid much memory impact generating textures on dragging.
    /// so each 150ms create the Image snapshot
    GTween.killTweensOf(_updateColorBytes);
    GTween.delayedCall(0.15, _updateColorBytes);
  }

  Future<void> _updateColorBytes() async {
    colorsBytes = await getImageBytes(colorsContainer);
    updateColor();
  }

  void updateColor() {
    if (colorsBytes == null) return;
    _selectedColor = getPixelColor(
      colorsBytes!,
      sw.toInt(),
      sh.toInt(),
      selector.x.toInt(),
      selector.y.toInt(),
    );

    /// emit the event to update the UI.
    pickerNotifier.value = _selectedColor!;
    // pickerMPS.emit1<Color>(ColorPickerEmitter.changeValue, _selectedColor);
  }
}
