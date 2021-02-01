import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as widgets;

import '../../graphx.dart';

class GIcon extends GDisplayObject {
  static final _sHelperMatrix = GMatrix();
  final _localBounds = GRect();

  @override
  GRect getBounds(GDisplayObject targetSpace, [GRect out]) {
    _sHelperMatrix.identity();
    getTransformationMatrix(targetSpace, _sHelperMatrix);
    var r = MatrixUtils.getTransformedBoundsRect(
      _sHelperMatrix,
      _localBounds,
      out,
    );
    return r;
  }

  @override
  GDisplayObject hitTest(GPoint localPoint, [bool useShape = false]) {
    if (!visible || !mouseEnabled) return null;
    return _localBounds.containsPoint(localPoint) ? this : null;
  }

  widgets.IconData _data;
  double _size;
  int _color;

  bool _invalidStyle = false;

  int get color => _color;

  set color(int value) {
    if (value == _color) return;
    _color = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  double get size => _size;

  set size(double value) {
    if (value == _size) return;
    _size = value;
    _localBounds?.setTo(0, 0, size, size);
    _invalidStyle = true;
    requiresRedraw();
  }

  widgets.IconData get data => _data;

  set data(widgets.IconData value) {
    if (value == _data) return;
    _data = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  GIcon(
    widgets.IconData data, [
    int color = 0xffffff,
    double size = 24.0,
  ]) {
    _data = data;
    _color = color;
    this.size = size;
    _setup();
  }

  @override
  set alpha(double value) {
    if ($alpha == value) return;
    super.alpha = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  ui.Paragraph _paragraph;
  ui.ParagraphBuilder _builder;
  ui.TextStyle _style;

  ui.Paint _paint;
  ui.Shadow _shadow;

  void setPaint(ui.Paint value) {
    _paint = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  void setShadow(ui.Shadow value) {
    _shadow = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  void _updateStyle() {
    if (_data == null) return;
    _style = ui.TextStyle(
      color: _paint == null ? ui.Color(color).withOpacity(alpha) : null,
      fontSize: _size,
      fontFamily: _resolveFontFamily(),
      foreground: _paint,
      shadows: _shadow != null ? [_shadow] : null,
    );
    _builder = ui.ParagraphBuilder(ui.ParagraphStyle());
    // _builder.pop();
    _builder.pushStyle(_style);
    final charCode = String.fromCharCode(_data.codePoint);
    _builder.addText(charCode);
    _paragraph = _builder.build();
    _paragraph.layout(ui.ParagraphConstraints(width: double.infinity));
    _invalidStyle = false;
  }

  String _resolveFontFamily() {
    if (data == null) return null;
    if (data.fontPackage == null) {
      return data.fontFamily;
    } else {
      return 'packages/${data.fontPackage}/${data.fontFamily}';
    }
  }

  void _setup() {
    _updateStyle();
  }

  @override
  void $applyPaint(ui.Canvas canvas) {
    if (data == null) return;
    if (_invalidStyle) {
      _invalidStyle = false;
      _updateStyle();
    }
    if (_paragraph != null) {
      canvas.drawParagraph(_paragraph, ui.Offset.zero);
    }
  }
}
