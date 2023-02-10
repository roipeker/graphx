import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as widgets;

import '../../graphx.dart';
import '../display/glyph_variation.dart';

class GIcon extends GDisplayObject {
  static final _sHelperMatrix = GMatrix();
  final _localBounds = GRect();

  @override
  GRect getBounds(GDisplayObject? targetSpace, [GRect? out]) {
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
  GDisplayObject? hitTest(GPoint localPoint, [bool useShape = false]) {
    if (!visible || !mouseEnabled) return null;
    return _localBounds.containsPoint(localPoint) ? this : null;
  }

  bool _invalidStyle = false;

  widgets.IconData? _data;
  double _size = 0.0;
  late ui.Color _color;

  ui.Color get color => _color;

  set color(ui.Color value) {
    if (value == _color) return;
    _color = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  double get size => _size;

  set size(double value) {
    if (value == _size) return;
    _size = value;
    _localBounds.setTo(0, 0, size, size);
    _invalidStyle = true;
    requiresRedraw();
  }

  widgets.IconData? get data => _data;

  set data(widgets.IconData? value) {
    if (value == _data) return;
    _data = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  GIcon(
    widgets.IconData data, [
    ui.Color color = kColorWhite,
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

  ui.Paragraph? _paragraph;
  late ui.ParagraphBuilder _builder;
  late ui.TextStyle _style;

  ui.Paint? _paint;
  ui.Shadow? _shadow;

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

  /// This TextStyle might be used to tweak the some properties not exposed
  /// directly in [GIcon]:
  /// height, background, leadingDistribution, letterSpacing, textBaseline,
  /// fontFeatures.
  widgets.TextStyle? _textStyle;
  widgets.TextStyle? get textStyle => _textStyle;
  set textStyle(widgets.TextStyle? value) {
    if (_textStyle == value) return;
    _textStyle = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  void _updateStyle() {
    if (_data == null) return;
    final realColor = color.withOpacity(color.opacity * $alpha);
    _style = ui.TextStyle(
      color: _paint == null ? realColor : null,
      fontSize: _size,
      fontFamily: _resolveFontFamily(),
      foreground: _paint,
      shadows: _shadow != null ? [_shadow!] : _textStyle?.shadows,
      fontVariations: _variations?.data,
      height: _textStyle?.height,
      background: _textStyle?.background,
      leadingDistribution: _textStyle?.leadingDistribution,
      letterSpacing: _textStyle?.letterSpacing,
      textBaseline: _textStyle?.textBaseline,
      fontFeatures: _textStyle?.fontFeatures,
    );
    _builder = ui.ParagraphBuilder(ui.ParagraphStyle());
    // _builder.pop();
    _builder.pushStyle(_style);
    final charCode = String.fromCharCode(_data!.codePoint);
    _builder.addText(charCode);
    _paragraph = _builder.build();
    _paragraph!.layout(const ui.ParagraphConstraints(width: double.infinity));
    _invalidStyle = false;
  }

  String? _resolveFontFamily() {
    if (data == null) return null;
    if (data!.fontPackage == null) {
      return data!.fontFamily;
    } else {
      return 'packages/${data!.fontPackage}/${data!.fontFamily}';
    }
  }

  void _setup() {
    _updateStyle();
  }

  @override
  void $applyPaint(ui.Canvas? canvas) {
    if (data == null) return;
    if (_invalidStyle) {
      _invalidStyle = false;
      _updateStyle();
    }
    if (_paragraph != null) {
      canvas!.drawParagraph(_paragraph!, ui.Offset.zero);
    }
  }

  GlyphVariations? _variations;

  GlyphVariations get variations {
    if (_variations == null) {
      _variations = GlyphVariations();
      _variations?.onUpdate = () {
        _invalidStyle = true;
        requiresRedraw();
      };
    }
    return _variations!;
  }

  /// See [GlyphVariations.weight].
  double? get weight => variations.weight;

  set weight(double? value) => variations.weight = value;

  /// See [GlyphVariations.grade].
  double? get grade => variations.grade;

  set grade(double? value) => variations.grade = value;

  /// See [GlyphVariations.opticalSize].
  double? get opticalSize => variations.opticalSize;

  set opticalSize(double? value) => variations.opticalSize = value;

  /// See [GlyphVariations.fill].
  double? get fill => variations.fill;

  set fill(double? value) => variations.fill = value;
}
