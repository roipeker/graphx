import 'dart:ui' as ui;

import 'package:flutter/widgets.dart' as widgets;

import '../../graphx.dart';
import '../display/glyph_variation.dart';

/// A display object that renders an icon from the [IconData] class. It
/// supports customizing the size, color, and font family of the icon.
class GIcon extends GDisplayObject {
  /// The helper matrix used for transforming bounds.
  static final _sHelperMatrix = GMatrix();

  /// The local bounds of the icon.
  final _localBounds = GRect();

  /// A flag indicating whether the icon's style is invalid and needs to be
  /// updated.
  bool _invalidStyle = false;

  /// The `IconData` object that represents the icon to be displayed.
  widgets.IconData? _data;

  /// The current size of the icon.
  double _size = 0.0;

  /// The current color of the icon.
  late ui.Color _color;

  /// The `Paragraph` object used for rendering the icon's glyph.
  ui.Paragraph? _paragraph;

  /// The `ParagraphBuilder` used for building the icon's text style.
  late ui.ParagraphBuilder _builder;

  /// The `TextStyle` used for rendering the icon's glyph.
  late ui.TextStyle _style;

  /// The `Paint` object used for rendering the icon's glyph.
  ui.Paint? _paint;

  /// The `Shadow` object used for rendering the icon's glyph.
  ui.Shadow? _shadow;

  /// This TextStyle might be used to tweak the some properties not exposed
  /// directly in [GIcon]:
  /// height, background, leadingDistribution, letterSpacing, textBaseline,
  /// fontFeatures.
  widgets.TextStyle? _textStyle;

  /// The `GlyphVariations` object used for customizing the icon's font
  /// variations.
  GlyphVariations? _variations;

  /// Creates a new instance of `GIcon` with the specified `IconData`, color,
  /// and size.
  GIcon(
    widgets.IconData data, [
    ui.Color color = kColorWhite,
    double size = 24.0,
  ]) {
    _data = data;
    _color = color;
    this.size = size;
    _updateStyle();
  }

  /// The transparency of the icon, from 0 (fully transparent) to 1 (fully
  /// opaque).
  ///
  /// When changing the alpha value, it will automatically trigger a redraw of
  /// the object.
  @override
  set alpha(double value) {
    if ($alpha == value) return;
    super.alpha = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  /// Gets the current color of the icon.
  ui.Color get color {
    return _color;
  }

  /// Sets the current color of the icon.
  set color(ui.Color color) {
    if (color == _color) {
      return;
    }
    _color = color;
    _invalidStyle = true;
    requiresRedraw();
  }

  /// Gets the `IconData` object that represents the icon to be displayed.
  widgets.IconData? get data {
    return _data;
  }

  /// Sets the `IconData` object that represents the icon to be displayed.
  set data(widgets.IconData? value) {
    if (value == _data) {
      return;
    }
    _data = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  /// * See [GlyphVariations.fill].
  double? get fill {
    return variations.fill;
  }

  set fill(double? fill) {
    variations.fill = fill;
  }

  /// * See [GlyphVariations.grade].
  double? get grade {
    return variations.grade;
  }

  set grade(double? grade) {
    variations.grade = grade;
  }

  /// * See [GlyphVariations.opticalSize].
  double? get opticalSize {
    return variations.opticalSize;
  }

  set opticalSize(double? opticalSize) {
    variations.opticalSize = opticalSize;
  }

  /// Gets the current size of the icon.
  double get size {
    return _size;
  }

  /// Sets the current size of the icon.
  set size(double value) {
    if (value == _size) {
      return;
    }
    _size = value;
    _localBounds.setTo(0, 0, size, size);
    _invalidStyle = true;
    requiresRedraw();
  }

  /// Gets the `TextStyle` object used for customizing the icon's text style.
  widgets.TextStyle? get textStyle {
    return _textStyle;
  }

  /// Sets the `TextStyle` object used for customizing the icon's text style.
  set textStyle(widgets.TextStyle? value) {
    if (_textStyle == value) return;
    _textStyle = value;
    _invalidStyle = true;
    requiresRedraw();
  }

  /// Returns the [GlyphVariations] instance for this [GIcon].
  ///
  /// The [GlyphVariations] is an object that allows to modify the
  /// glyph weight, grade, optical size and fill of the text.
  ///
  /// See also:
  ///
  /// * [GlyphVariations], the class for the variations object.
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

  /// * See [GlyphVariations.weight].
  double? get weight {
    return variations.weight;
  }

  set weight(double? weight) {
    variations.weight = weight;
  }

  /// (Internal usage)
  /// Applies the current paint to the [canvas], drawing the glyph using a
  /// [ui.Paint] object, updating it if necessary.
  ///
  /// This method overrides the base implementation to avoid using a shape
  /// renderer to draw the glyph. Instead, it directly draws the glyph using a
  /// [ui.Canvas] object and a [ui.Paint] object.
  ///
  /// The paint object used to draw the glyph is updated only if necessary. The
  /// method checks if any of the style properties have changed (such as color,
  /// size, font family, font variations, etc.). If any change is detected,
  /// [_updateStyle()] is called to update the style.
  ///
  /// Once the style is updated, the method draws the glyph using a
  /// [ui.ParagraphBuilder] object and a [ui.Paragraph] object, which are
  /// created by [_updateStyle()]. Finally, it draws the paragraph to the
  /// [canvas] using the [ui.Canvas.drawParagraph()] method.
  ///
  /// Note that the paragraph is always drawn at the origin, so its position
  /// must be transformed by the transformation matrix to get the final position
  /// of the glyph.
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

  /// Returns the axis-aligned bounding rectangle of the object relative to the
  /// [targetSpace] object. If [targetSpace] is null, the bounds will be
  /// relative to this object's parent.
  ///
  /// An optional [out] parameter can be provided to avoid creating a new
  /// [GRect] instance on every call.
  ///
  /// The method applies a matrix transformation to the bounds of the object
  /// to align it with the new coordinate space. If you pass a non-null
  /// [targetSpace] matrix, the method automatically multiplies the object's
  /// matrix transform by the matrix of the target coordinate space.
  ///
  /// If [targetSpace] is not an ancestor of this object or if it is null,
  /// returns the bounds in this object's local coordinate space.
  @override
  GRect getBounds(GDisplayObject? targetSpace, [GRect? out]) {
    _sHelperMatrix.identity();
    getTransformationMatrix(targetSpace, _sHelperMatrix);
    return MatrixUtils.getTransformedBoundsRect(
      _sHelperMatrix,
      _localBounds,
      out,
    );
  }

  /// Determines whether the specified [localPoint] is within the bounds of this
  /// icon.
  ///
  /// This implementation is specific to [GIcon] and only tests whether the
  /// point is within the local bounds of the icon.
  @override
  GDisplayObject? hitTest(GPoint localPoint, [bool useShape = false]) {
    if (!visible || !mouseEnabled) {
      return null;
    }
    return _localBounds.containsPoint(localPoint) ? this : null;
  }

  /// Sets the [ui.Paint] [paint] for the icon.
  void setPaint(ui.Paint paint) {
    _paint = paint;
    _invalidStyle = true;
    requiresRedraw();
  }

  /// Sets the [ui.Shadow] value for the icon.
  void setShadow(ui.Shadow shadow) {
    _shadow = shadow;
    _invalidStyle = true;
    requiresRedraw();
  }

  /// Resolves the font family for the icon data.
  ///
  /// It checks if the font package is null or not, and returns the appropriate
  /// font family path. If the font package is null, it returns the font family
  /// as is.
  String? _resolveFontFamily() {
    if (data == null) {
      return null;
    }
    if (data!.fontPackage == null) {
      return data!.fontFamily;
    } else {
      return 'packages/${data!.fontPackage}/${data!.fontFamily}';
    }
  }

  /// Updates the text style of the icon, based on its properties such as color,
  /// size, font family, and variations. This method also builds the icon's
  /// paragraph using the updated style, which can be drawn onto a canvas in the
  /// $applyPaint() method. This method sets [_invalidStyle] to false once it's
  /// finished updating the style and building the paragraph.
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
}
