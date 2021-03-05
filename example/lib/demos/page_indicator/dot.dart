import 'dart:ui';

import 'package:graphx/graphx.dart';

class PageDot extends GShape {

  int id;

  double _baseSize;

  Color _color;

  Color get color => _color;

  set color(Color value) {
    if (value == _color) return;
    _color = value;
    _invalidateDraw();
  }

  double _size;
  double targetSize;

  double get size => _size;

  set size(double value) {
    if (value < _baseSize) value = _baseSize;
    if (value == _size) return;
    _size = value;
    _invalidateDraw();
    // _draw();
  }

  PageDot(this.id, double baseSize, Color color) {
    // w = h = size;
    _color = color;
    targetSize = _size = _baseSize = baseSize;
    _invalidateDraw();
    // _draw();
  }

  void _draw() {
    graphics
        .clear()
        .beginFill(_color)
        .drawRoundRect(0, 0, _size, _baseSize, _baseSize / 2)
        .endFill();
  }

  bool _isInvalid = true;

  void validate() {
    _isInvalid = false;
    _draw();
  }

  void _invalidateDraw() {
    if (_isInvalid) return;
    _isInvalid = true;
  }

  @override
  void update(double delta) {
    super.update(delta);
    // _size += (_targetSize-_size)/10;
    // _isInvalid=true;
    if (_isInvalid) {
      _isInvalid = false;
      validate();
    }

  }
}
