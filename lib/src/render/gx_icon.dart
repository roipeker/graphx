import 'dart:ui';

import 'package:flutter/widgets.dart' as widgets;

import '../../graphx.dart';

class GxIcon extends DisplayObject {
  static final _sHelperMatrix = GxMatrix();
  final _localBounds = GxRect();

  @override
  GxRect getBounds(DisplayObject targetSpace, [GxRect out]) {
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
  DisplayObject hitTest(GxPoint localPoint, [bool useShape = false]) {
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

  GxIcon(
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

  Paragraph _paragraph;
  ParagraphBuilder _builder;
  TextStyle _style;

  Paint _paint;
  Shadow _shadow;

  void setPaint(Paint value) {
    _paint = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  void setShadow(Shadow value) {
    _shadow = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  void _updateStyle() {
    if (_data == null) return;
    _style = TextStyle(
      color: _paint == null ? Color(color).withOpacity(alpha) : null,
      fontSize: _size,
      fontFamily: _resolveFontFamily(),
      foreground: _paint,
      shadows: _shadow != null ? [_shadow] : null,
    );
    _builder = ParagraphBuilder(ParagraphStyle());
    // _builder.pop();
    _builder.pushStyle(_style);
    final charCode = String.fromCharCode(_data.codePoint);
    _builder.addText(charCode);
    _paragraph = _builder.build();
    _paragraph.layout(ParagraphConstraints(width: double.infinity));
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
  void $applyPaint(Canvas canvas) {
    if (data == null) return;
    if (_invalidStyle) {
      _invalidStyle = false;
      _updateStyle();
    }
    if (_paragraph != null) {
      canvas.drawParagraph(_paragraph, Offset.zero);
    }
  }
}
