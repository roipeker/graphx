import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

class MyButton extends Sprite {
  double w = 80;
  double h = 80;

  Shape bg;
  Shape fillBg;
  GxIcon icon;

  bool _isTouching = false;
  bool _isOn = false;
  double _fillPercent = 0.0;

  MyButton() {}

  @override
  void addedToStage() {
    bg = Shape();
    _dragBackground(bg.graphics, Colors.black);

    fillBg = Shape();
    _dragBackground(fillBg.graphics, Colors.yellow.shade800);
    _updateFill();

    icon = GxIcon(null);
    _updateIcon();

    icon.alignPivot();
    icon.x = w / 2;
    icon.y = h / 2;

    addChild(bg);
    addChild(fillBg);
    addChild(icon);
    alignPivot();
    // take the Sprite as an entire active area.
    // disable children from recieving pointer events.
    mouseChildren = false;

    onMouseDown.add(_onMouseDown);
    onMouseOver.add(_onMouseOver);
    onMouseOut.add(_onMouseOut);

    // only on desktop.
    onMouseScroll.add(_onMouseScroll);
  }

  void _dragBackground(Graphics g, Color color) {
    /// when you wanna redraw a Shape and not "add" to the current drawing...
    /// always clear() it first.
    g.clear().beginFill(color.value).drawRoundRect(0, 0, w, h, 12).endFill();
  }

  void toggleButton() {
    _isOn = !_isOn;
    _updateIcon();
  }

  void _updateIcon() {
    if (_isOn) {
      icon.data = Icons.wb_incandescent;
      icon.color = Colors.yellow.value;
    } else {
      icon.data = Icons.wb_incandescent_outlined;
      icon.color = Colors.white.value;
    }
  }

  void _onMouseDown(MouseInputData input) {
    scale = .8;
    stage.onMouseUp.addOnce(_onRelase);
  }

  void _onMouseScroll(MouseInputData input) {
    /// take the direction of the scroll wheel
    var scrollDir = input.scrollDelta.y < 0 ? 1 : -1;
    _fillPercent += .01 * scrollDir;
    _fillPercent = _fillPercent.clamp(0.0, 1.0);
    _updateFill();
  }

  void _updateFill() {
    fillBg.alpha = _fillPercent;
    fillBg.scaleY = _fillPercent;
  }

  void _onMouseOver(MouseInputData input) {
    _dragBackground(bg.graphics, Colors.grey.shade800);
    _isTouching = true;
  }

  void _onMouseOut(MouseInputData input) {
    _dragBackground(bg.graphics, Colors.black);
    _isTouching = false;
  }

  void _onRelase(MouseInputData input) {
    scale = 1;
    if (_isTouching) {
      toggleButton();
    }
  }
}
