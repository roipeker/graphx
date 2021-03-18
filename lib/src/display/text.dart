import 'dart:ui' as ui;
import 'package:flutter/painting.dart' as painting;
import '../../graphx.dart';

class GText extends GDisplayObject {
  ui.Paragraph? _paragraph;

  Signal? _onFontLoaded;

  Signal get onFontLoaded => _onFontLoaded ??= Signal();

  static final _sHelperMatrix = GMatrix();

  /// TODO: check if Paint is required locally in every DisplayObject.
  final _alphaPaint = ui.Paint();

  @override
  GRect getBounds(GDisplayObject? targetSpace, [GRect? out]) {
    validate();
    out ??= GRect();
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

  ui.Paragraph? get paragraph => _paragraph;

  // ui.TextStyle _style;
  painting.TextStyle? _style;

  double _width = 0.0;

  late ui.ParagraphBuilder _builder;
  ui.ParagraphStyle? _paragraphStyle;

  bool _invalidSize = true;
  bool _invalidBuilder = true;
  String? _text;
  ui.Color? backgroundColor;

  ui.Color? get color {
    return _style!.color;
  }

  set color(ui.Color? value) {
    _style = _style!.copyWith(color: value);
    _invalidBuilder = true;
    // _invalidateBuilder();
  }

  /// TODO: implement this.
//  TextFormat get format => _format;
//  set format(TextFormat value) {
//    if (_format == value) return;
//    _format = value;
////    _invalidBuilder = true;
//  }

  String get text => _text ?? '';

  set text(String? value) {
    if (_text == value) return;
    _text = value ?? '';
    _invalidBuilder = true;
  }

  /// deprecated.
  @override
  double get width => _width;

  @override
  set width(double? value) {
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

  static painting.TextStyle defaultTextStyle = painting.TextStyle(
    color: kColorBlack,
    decorationStyle: ui.TextDecorationStyle.solid,
  );

  static ui.ParagraphStyle defaultParagraphStyle = ui.ParagraphStyle(
    fontWeight: ui.FontWeight.normal,
    fontSize: 12,
    textAlign: ui.TextAlign.left,
  );

  // static ui.TextStyle getStyle({
  //   ui.Color color,
  //   ui.TextDecoration decoration,
  //   ui.Color decorationColor,
  //   ui.TextDecorationStyle decorationStyle,
  //   double decorationThickness,
  //   ui.FontWeight fontWeight,
  //   ui.FontStyle fontStyle,
  //   ui.TextBaseline textBaseline,
  //   String fontFamily,
  //   List<String> fontFamilyFallback,
  //   double fontSize,
  //   double letterSpacing,
  //   double wordSpacing,
  //   double height,
  //   ui.Locale locale,
  //   ui.Paint background,
  //   ui.Paint foreground,
  //   List<ui.Shadow> shadows,
  //   List<ui.FontFeature> fontFeatures,
  // }) {
  //   return ui.TextStyle(
  //     color: color,
  //     decoration: decoration,
  //     decorationColor: decorationColor,
  //     decorationStyle: decorationStyle,
  //     decorationThickness: decorationThickness,
  //     fontWeight: fontWeight,
  //     fontStyle: fontStyle,
  //     textBaseline: textBaseline,
  //     fontFamily: fontFamily,
  //     fontFamilyFallback: fontFamilyFallback,
  //     fontSize: fontSize,
  //     letterSpacing: letterSpacing,
  //     wordSpacing: wordSpacing,
  //     height: height,
  //     locale: locale,
  //     background: background,
  //     foreground: foreground,
  //     shadows: shadows,
  //     fontFeatures: fontFeatures,
  //   );
  // }

  GText({
    String? text,
    ui.ParagraphStyle? paragraphStyle,
    painting.TextStyle? textStyle,
    double width = double.infinity,
  }) {
    painting.PaintingBinding.instance!.systemFonts.addListener(_fontLoaded);
    this.text = text;

    _width = width;
    _invalidBuilder = true;
    _invalidSize = true;
    setTextStyle(textStyle ?? defaultTextStyle);
    setParagraphStyle(paragraphStyle ?? defaultParagraphStyle);
  }

  void _fontLoaded() {
    _invalidBuilder = true;
    _invalidateBuilder();
    _onFontLoaded?.dispatch();
  }

  @override
  void dispose() {
    super.dispose();
    painting.PaintingBinding.instance!.systemFonts.removeListener(_fontLoaded);
    _onFontLoaded?.removeAll();
    _onFontLoaded = null;
  }

  void setTextStyle(painting.TextStyle style) {
    if (_style == style) return;
    _style = style;
    _invalidBuilder = true;
  }

  painting.TextStyle? getTextStyle() => _style;

  ui.ParagraphStyle? getParagraphStyle() => _paragraphStyle;

  void setParagraphStyle(ui.ParagraphStyle style) {
    if (_paragraphStyle == style) return;
    _paragraphStyle = style;
    _invalidBuilder = true;
  }

  void _invalidateBuilder() {
    _paragraphStyle ??= defaultParagraphStyle;
    _builder = ui.ParagraphBuilder(_paragraphStyle!);
    // if (_style != null) _builder.pushStyle(_style);
    if (_style != null) _builder.pushStyle(_style!.getTextStyle());
    _builder.addText(_text ?? '');
    _paragraph = _builder.build();
    _invalidBuilder = false;
    _invalidSize = true;
  }

  static const double _maxTextWidthForWeb = 10000;

  void _layout() {
    //// Web has a bug for double.infinity for text layout.
    var paragraphWidth = !SystemUtils.usingSkia ? _maxTextWidthForWeb : _width;
    _paragraph?.layout(ui.ParagraphConstraints(width: paragraphWidth));
    _invalidSize = false;
  }

  /// Warning: Internal method.
  /// applies the painting after the DisplayObject transformations.
  /// Should be overriden by subclasses.
  @override
  void $applyPaint(ui.Canvas? canvas) {
    super.$applyPaint(canvas);
    if (_text == '') return;
    validate();
    if (backgroundColor != null && backgroundColor!.alpha > 0) {
      canvas!.drawRect(
        ui.Rect.fromLTWH(0, 0, intrinsicWidth, textHeight),
        ui.Paint()..color = backgroundColor!,
      );
    }
    if (_paragraph != null) {
      if ($alpha != 1.0) {
//        print("ALPHA is: $alpha");
//        final alphaPaint = PainterUtils.getAlphaPaint($alpha);
//        final alphaPaint = _alphaPaint;
//        var bounds = Rect.fromLTWH(0, 0, textWidth, textHeight);
        canvas!.saveLayer(null, _alphaPaint);
        canvas.drawParagraph(_paragraph!, ui.Offset.zero);
        canvas.restore();
      } else {
        canvas!.drawParagraph(_paragraph!, ui.Offset.zero);
      }
    }
  }

  @override
  set alpha(double value) {
    final changed = value != $alpha;
    super.alpha = value;
    if (changed) {
      _alphaPaint.color = _alphaPaint.color.withOpacity($alpha);
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

  /// Factory method to simplify the initialization of a StaticText instance.
  /// You can pass the parent object directly in the `doc` parameter.
  static GText build({
    String? text,
    GDisplayObjectContainer? doc,
    ui.Color? color,
    double w = double.infinity,
    ui.TextDecoration? decoration,
    ui.Color? decorationColor,
    ui.TextDecorationStyle? decorationStyle,
    double? decorationThickness,
    ui.FontWeight? fontWeight,
    ui.FontStyle? fontStyle,
    ui.TextBaseline? textBaseline,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? fontSize,
    double? letterSpacing,
    double? wordSpacing,
    double? height,
    ui.Locale? locale,
    ui.Paint? background,
    ui.Paint? foreground,
    String? ellipsis,
    int? maxLines,
    List<ui.Shadow>? shadows,
    List<ui.FontFeature>? fontFeatures,
    ui.TextAlign textAlign = ui.TextAlign.left,
    ui.TextDirection direction = ui.TextDirection.ltr,
  }) {
    if (w == double.infinity && textAlign != ui.TextAlign.left) {
      throw "[StaticText] To use $textAlign you need to specify the width";
    }
    final style = painting.TextStyle(
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
    final tf = GText(
      text: text,
      width: w,
      textStyle: style,
      paragraphStyle: ui.ParagraphStyle(
        maxLines: maxLines,
        ellipsis: ellipsis,
        textAlign: textAlign,
        textDirection: direction,
      ),
    );
    doc?.addChild(tf);
    return tf;
  }
}
