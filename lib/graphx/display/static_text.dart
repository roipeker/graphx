import 'dart:ui';

import 'package:graphx/graphx/display/display_object.dart';
import 'package:graphx/graphx/geom/gxmatrix.dart';
import 'package:graphx/graphx/geom/gxrect.dart';
import 'package:graphx/graphx/utils/matrix_utils.dart';
import 'package:graphx/graphx/utils/painter_utils.dart';

class StaticText extends IAnimatable {
  Paragraph _paragraph;

  static GxMatrix _sHelperMatrix = GxMatrix();

  @override
  GxRect getBounds(IAnimatable targetSpace, [GxRect out]) {
    validate();
    out ??= GxRect();
    out.setTo(0, 0, intrinsicWidth, textHeight);
    if (targetSpace == this) {
      /// optimization.
      return out;
    } else {}
    final matrix = _sHelperMatrix;
    matrix.identity();
    getTransformationMatrix(targetSpace, matrix);
    MatrixUtils.getTransformedBoundsRect(matrix, out, out);
    return out;
  }

//  Rect getBounds([DisplayObject relativeTo]) {
//    validate();
//    if (relativeTo == this) {
//      return Rect.fromLTWH(0, 0, intrinsicWidth, textHeight);
//    }
//    Rect r = Rect.fromLTWH(x, y, textWidth, textHeight);
//    if (scaleX != 1 || scaleY != 1) {
//      r = Rect.fromLTWH(r.left, r.top, r.right * scaleX, r.bottom * scaleY);
//    }
//    return r;
//  }

  Paragraph get paragraph => _paragraph;
  TextStyle _style;
  double _width;

  ParagraphBuilder _builder;
  ParagraphStyle _paragraphStyle;

  bool _invalidSize = true;
  bool _invalidBuilder = true;
  String _text;
  Color backgroundColor;

  /// TODO: implement this.
//  TextFormat get format => _format;
//  set format(TextFormat value) {
//    if (_format == value) return;
//    _format = value;
////    _invalidBuilder = true;
//  }

  String get text => _text ?? '';

  set text(String value) {
    if (_text == value) return;
    _text = value ?? '';
    _invalidBuilder = true;
  }

  /// deprecated.
  double get width => _width;

  set width(double value) {
    if (value == null || _width == value) return;
    _width = value;
    _invalidSize = true;
  }

  double get textWidth {
    return _paragraph?.maxIntrinsicWidth ?? 0;
  }

  double get textHeight {
    return _paragraph?.height ?? 0;
  }

  static TextStyle defaultTextStyle = TextStyle(
    color: Color(0xff000000),
    decorationStyle: TextDecorationStyle.solid,
  );

  static ParagraphStyle defaultParagraphStyle = ParagraphStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    textAlign: TextAlign.left,
  );

  static TextStyle getStyle({
    Color color,
    TextDecoration decoration,
    Color decorationColor,
    TextDecorationStyle decorationStyle,
    double decorationThickness,
    FontWeight fontWeight,
    FontStyle fontStyle,
    TextBaseline textBaseline,
    String fontFamily,
    List<String> fontFamilyFallback,
    double fontSize,
    double letterSpacing,
    double wordSpacing,
    double height,
    Locale locale,
    Paint background,
    Paint foreground,
    List<Shadow> shadows,
    List<FontFeature> fontFeatures,
  }) {
    return TextStyle(
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      textBaseline: textBaseline,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFamilyFallback,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      locale: locale,
      background: background,
      foreground: foreground,
      shadows: shadows,
      fontFeatures: fontFeatures,
    );
  }

  StaticText({
    String text,
    ParagraphStyle paragraphStyle,
    TextStyle textStyle,
    double width = double.infinity,
  }) {
    this.text = text;
    _width = width;
    _invalidBuilder = true;
    _invalidSize = true;
    setTextStyle(textStyle ?? defaultTextStyle);
    setParagraphStyle(paragraphStyle ?? defaultParagraphStyle);
  }

  void setTextStyle(TextStyle style) {
    if (style == null || _style == style) return;
    _style = style;
    _invalidBuilder = true;
  }

  TextStyle getTextStyle() {
    return _style;
  }

  ParagraphStyle getParagraphStyle() {
    return _paragraphStyle;
  }

  void setParagraphStyle(ParagraphStyle style) {
    if (style == null || _paragraphStyle == style) return;
    _paragraphStyle = style;
    _invalidBuilder = true;
  }

  void _invalidateBuilder() {
    _builder = ParagraphBuilder(_paragraphStyle);
    if (_style != null) _builder.pushStyle(_style);
    _builder.addText(_text ?? '');

    _paragraph = _builder.build();
    _invalidBuilder = false;
    _invalidSize = true;
  }

  void _layout() {
    _paragraph?.layout(ParagraphConstraints(width: _width));
    _invalidSize = false;
  }

  @override
  void $applyPaint() {
    super.$applyPaint();
    if (_text == '') return;
    validate();
    if (backgroundColor != null && backgroundColor.alpha > 0) {
      $canvas.drawRect(
        Rect.fromLTWH(0, 0, intrinsicWidth, textHeight),
        Paint()..color = backgroundColor,
      );
    }
    if (_paragraph != null) {
      if (alpha != 1) {
        Rect bounds = Rect.fromLTWH(0, 0, textWidth, textHeight);
        final alphaPaint = PainterUtils.getAlphaPaint(alpha);
        $canvas.saveLayer(bounds, alphaPaint);
        $canvas.drawParagraph(_paragraph, Offset.zero);
        $canvas.restore();
      } else {
        $canvas.drawParagraph(_paragraph, Offset.zero);
      }
    }
  }

  double get intrinsicWidth => width == double.infinity ? textWidth : width;

  void validate() {
    if (_invalidBuilder) {
      _invalidateBuilder();
      _invalidBuilder = false;
    }
    if (_invalidSize || _invalidBuilder) {
      _layout();
      _invalidSize = false;
      _invalidBuilder = false;
    }
  }

//  @override
//  Future<GTexture> createImageTexture([
//    bool adjustOffset = true,
//    double resolution = 1,
//    Rect rect,
//  ]) async {
//    validate();
//    return super.createImageTexture(adjustOffset, resolution, rect);
//  }

}
