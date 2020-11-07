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

  /// Draws a rounded cornder rectangle with the current w and h in any
  /// 'Graphics' that we passed [g], painted with the given [color] and
  /// clearing previous draw commands.
  void _dragBackground(Graphics g, Color color) {
    /// when you wanna redraw a Shape and not "add" to the current drawing...
    /// always clear() it first.
    g.clear().beginFill(color.value).drawRoundRect(0, 0, w, h, 12).endFill();
  }

  /// Toggles [_isOn] property between true/false, and updates the icon
  /// state.
  void toggleButton() {
    _isOn = !_isOn;
    _updateIcon();
  }

  /// Handler for pointer down (mouse or touch).
  void _onMouseDown(MouseInputData input) {
    scale = .8;
    stage.onMouseUp.addOnce(_onStageRelase);
  }

  /// Handler for mouse scroll wheel (only desktop).
  void _onMouseScroll(MouseInputData input) {
    /// take the direction of the scroll wheel
    var scrollDir = input.scrollDelta.y < 0 ? 1 : -1;
    _fillPercent += .01 * scrollDir;
    _fillPercent = _fillPercent.clamp(0.0, 1.0);
    _updateFill();
  }

  /// handler for mouse over.
  /// this happens when the mouse enters into the bounding box area
  /// of the object that is listening for this signal.
  /// Means that the pointer started to interact with this object.
  /// Similar to "onmouseover" in Javascript.
  void _onMouseOver(MouseInputData input) {
    _dragBackground(bg.graphics, Colors.grey.shade800);
    _isTouching = true;
  }

  /// handler for mouse out.
  /// happens when the mouse leaves the bounding box area of this
  /// object..
  /// Means that the pointer is no longer interacting with this object.
  /// Similar to "onmouseout" in Javascript.
  void _onMouseOut(MouseInputData input) {
    _dragBackground(bg.graphics, Colors.black);
    _isTouching = false;
  }

  /// handler for mouse up on the stage.
  /// Mouse up is like "touchEnd" or "onRelease", when the interaction
  /// finishes, we listen to the [stage] event cause the stage occupies the
  /// entire [Canvas] in GraphX. So if the user press and "drags" outside the
  /// bounds of the object, we can still get a callback. That's why we used
  /// [onMouseOver] and [onMouseOut] to know if we are releasing inside the
  /// object ("click" or [onTap] in Flutter's world) or not.
  void _onStageRelase(MouseInputData input) {
    scale = 1;
    if (_isTouching) {
      toggleButton();
    }
  }

  /// update the [icon.data] and icon's color, based on [_isOn] current state.
  void _updateIcon() {
    if (_isOn) {
      icon.data = Icons.wb_incandescent;
      icon.color = Colors.yellow.value;
    } else {
      icon.data = Icons.wb_incandescent_outlined;
      icon.color = Colors.white.value;
    }
  }

  /// updates the [fillBg] Shape based on [_fillPercent]
  /// so it scales down (scaleY) and fades in (alpha) as _fillPercent
  /// goes from 0 (fully hidden) to 1 (fully shown).
  void _updateFill() {
    fillBg.alpha = _fillPercent;
    fillBg.scaleY = _fillPercent;
  }
}
