import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:graphx/graphx.dart';

class MyButton extends GSprite {
  // variables to define the size of the button.
  double w = 80;
  double h = 80;

  // backwards background (black)
  GShape bg;

  // filled background that changes with [_fillPercent] (yellow)
  GShape fillBg;

  // the light bulb icon that toggles when clicking the button
  GIcon icon;

  bool _isTouching = false;
  bool _isOn = false;
  double _fillPercent = 0.0;

  GText _fillText;

  MyButton() {
    _init();
  }

  /// we dont make usage of stage, so is safe to initialize all objects
  /// as soon as we instantiate [MyButton].
  void _init() {
    bg = GShape();
    _dragBackground(bg.graphics, Colors.black);

    fillBg = GShape();
    _dragBackground(fillBg.graphics, Colors.yellow.shade800);

    icon = GIcon(null);
    _updateIcon();

    icon.alignPivot();
    icon.x = w / 2;
    icon.y = h / 2;

    /// add all children into this Sprite.
    addChild(bg);
    addChild(fillBg);
    addChild(icon);
    // center the pivot based on the current size.
    alignPivot();

    /// now add the text to the side, "outside"
    /// of button area...
    _initText();

    /// update the button state to the default values.
    _updateFill();

    // Takes the Sprite as an whole active area.
    // disable children from receiving pointer events.
    mouseChildren = false;

    onMouseOver.add(_onMouseOver);
    onMouseDown.add(_onMouseDown);
    onMouseOut.add(_onMouseOut);

    // only on desktop.
    onMouseScroll.add(_onMouseScroll);
  }

  void _initText() {
    _fillText = GText(
      text: '0%',
      textStyle: TextStyle(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );

    /// disable the touch interaction for the text.
    /// we dont want this affecting the buttons states
    _fillText.mouseEnabled = false;
    _fillText.x = w + 5;
    addChild(_fillText);
  }

  /// Draws a rounded cornder rectangle with the current w and h in any
  /// 'Graphics' that we passed [g], painted with the given [color] and
  /// clearing previous draw commands.
  void _dragBackground(Graphics g, Color color) {
    /// when you wanna redraw a Shape and not "add" to the current drawing...
    /// always clear() it first.
    g.clear().beginFill(color).drawRoundRect(0, 0, w, h, 12).endFill();
  }

  /// Toggles [_isOn] property between true/false, and updates the icon
  /// state.
  void toggleButton() {
    _isOn = !_isOn;
    _updateIcon();
  }

  /// Handler for pointer down (mouse or touch).
  void _onMouseDown(MouseInputData input) {
    scale = .94;
    stage.onMouseUp.addOnce(_onStageRelease);
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
    alpha = .9;
    _fillText.visible = true;
    _isTouching = true;
  }

  /// handler for mouse out.
  /// happens when the mouse leaves the bounding box area of this
  /// object..
  /// Means that the pointer is no longer interacting with this object.
  /// Similar to "onmouseout" in Javascript.
  void _onMouseOut(MouseInputData input) {
    alpha = 1;
    _fillText.visible = false;
    _isTouching = false;
  }

  /// handler for mouse up on the stage.
  /// Mouse up is like "touchEnd" or "onRelease", when the interaction
  /// finishes, we listen to the [stage] event cause the stage occupies the
  /// entire [Canvas] in GraphX. So if the user press and "drags" outside the
  /// bounds of the object, we can still get a callback. That's why we used
  /// [onMouseOver] and [onMouseOut] to know if we are releasing inside the
  /// object ("click" or [onTap] in Flutter's world) or not.
  void _onStageRelease(MouseInputData input) {
    scale = 1;
    if (_isTouching) {
      toggleButton();
    }
  }

  /// update the [icon.data] and icon's color, based on [_isOn] current state.
  void _updateIcon() {
    if (_isOn) {
      icon.data = Feather.sun;
      icon.color = Colors.yellow;
    } else {
      icon.data = Feather.moon;
      icon.color = Colors.white;
    }
  }

  /// updates the [fillBg] Shape based on [_fillPercent]
  /// so it scales down (scaleY) and fades in (alpha) as _fillPercent
  /// goes from 0 (fully hidden) to 1 (fully shown).
  /// and updates the text position based on the height of the button.
  void _updateFill() {
    _updateFillText();
    fillBg.alpha = _fillPercent;
    fillBg.scaleY = _fillPercent;
  }

  void _updateFillText() {
    /// position the text based on the %.
    var textH = _fillText.textHeight;

    /// textH/2 is the vertical center of the text.
    /// as we wanna match the fillBg line, we offset that value
    /// so it looks centered.
    var textY = _fillPercent * h - textH / 2;

    /// and we limit the position so it moves inside the button's
    /// height
    textY = textY.clamp(0.0, h - textH);
    _fillText.y = textY;
    _fillText.text = '${(_fillPercent * 100).toStringAsFixed(0)}%';
    _fillText.alpha = _fillPercent.clamp(.3, 1.0);
  }
}
