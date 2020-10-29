import 'dart:ui';

import 'package:flutter/widgets.dart' as widgets;

import '../../graphx.dart';

class GxIcon extends IAnimatable {
  static final _sHelperMatrix = GxMatrix();
  final _localBounds = GxRect();

  @override
  GxRect getBounds(IAnimatable targetSpace, [GxRect out]) {
    _sHelperMatrix.identity();
    getTransformationMatrix(targetSpace, _sHelperMatrix);
    return MatrixUtils.getTransformedBoundsRect(
      _sHelperMatrix,
      _localBounds,
      out,
    );
  }

  @override
  IAnimatable hitTest(GxPoint localPoint, [bool useShape = false]) {
    if (!visible || !touchable) return null;
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

  widgets.IconData get icon => _data;

  set icon(widgets.IconData value) {
    if (value == _data) return;
    _data = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  GxIcon(data, [color = 0xffffff, size = 24.0]) {
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
    _style = TextStyle(
      color: _paint == null ? Color(color).withOpacity(alpha) : null,
      fontSize: _size,
      fontFamily: _resolveFontFamily(),
      foreground: _paint,
      shadows: _shadow != null ? [_shadow] : null,
    );
    _builder.pop();
    _builder.pushStyle(_style);
    final charCode = String.fromCharCode(_data.codePoint);
    _builder.addText(charCode);
    _paragraph = _builder.build();
    _paragraph.layout(ParagraphConstraints(width: double.infinity));
    _invalidStyle = false;
  }

  String _resolveFontFamily() {
    if (icon == null) return null;
    if (icon.fontPackage == null) {
      return icon.fontFamily;
    } else {
      return 'packages/${icon.fontPackage}/${icon.fontFamily}';
    }
  }

  void _setup() {
    _builder = ParagraphBuilder(ParagraphStyle());
    _updateStyle();
  }

  @override
  void $applyPaint() {
    if (icon == null) return;
    if (_invalidStyle) {
      _invalidStyle = false;
      _updateStyle();
    }
    if (_paragraph != null) {
      $canvas.drawParagraph(_paragraph, Offset.zero);
    }
  }
}
