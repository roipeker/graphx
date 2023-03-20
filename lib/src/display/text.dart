import 'dart:ui' as ui;

import 'package:flutter/painting.dart' as painting;

import '../../graphx.dart';

/// A display object representing a text element that can be added to the display list.
///
/// Use [GText] to display a simple, single-line, static text element on the stage.
///
/// You can specify the text content, text style, and paragraph style, and the width of the
/// text element to control the text layout. By default, the [GText] uses a system font for the
/// specified font family.
///
/// You can also use the static [GText.build] method to create a [GText] object
/// with a set of predefined text styles.
class GText extends GDisplayObject {
  ui.Paragraph? _paragraph;

  Signal? _onFontLoaded;

  /// A signal dispatched when the font is loaded.
  ///
  /// Dispatched when a font is loaded on the text field.
  /// Use this signal to handle the completion of font loading.
  Signal get onFontLoaded => _onFontLoaded ??= Signal();

  static final _sHelperMatrix = GMatrix();

  /// TODO: check if Paint is required locally in every DisplayObject.
  final _alphaPaint = ui.Paint();

  /// Returns the bounds of the text in the target coordinate space.
  ///
  /// The [targetSpace] parameter determines the coordinate space of the returned
  /// bounds object. You can use this parameter to get the bounds of the text
  /// relative to any display object.
  ///
  /// If the [targetSpace] parameter is not passed, the method returns the bounds
  /// of the text in its local coordinate space.
  ///
  /// By default, the bounds object returned by this method contains the text's
  /// dimensions.
  ///
  /// If the method is called with an existing [out] parameter, the returned
  /// value will be the same as the [out] parameter. This is useful when you
  /// want to avoid creating a new bounds GRect object.
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

  /// Getter for the [_paragraph] variable.
  /// Returns the [ui.Paragraph] instance that contains the text and its styling
  /// information. The [ui.Paragraph] instance is created by the [_invalidateBuilder]
  /// method when the text or its style is updated. The [_layout] method then
  /// lays out the text in the paragraph, updating its size.
  /// Returns null if the paragraph is invalid or not created yet.
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

  /// Returns the color of the text.
  ui.Color? get color => _style!.color;

  /// Sets the color of the text.
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

  /// The text string that will be displayed.
  String get text => _text ?? '';

  /// Sets the text content of the [GText].
  set text(String? value) {
    if (_text == value) return;
    _text = value ?? '';
    _invalidBuilder = true;
  }

  /// The [width] of the text. If not explicitly set, it returns [double.infinity].
  /// Setting a value to this property will invalidate the size of the text
  /// and trigger a rebuild on the next render.
  @override
  double get width => _width;

  /// Sets the [width] of the text. Setting a new value will invalidate the size
  /// of the text and trigger a rebuild on the next render.
  @override
  set width(double? value) {
    if (value == null || _width == value) return;
    _width = value;
    _invalidSize = true;
  }

  /// The textWidth method returns the maximum intrinsic width of the text
  /// within the [GText] object.
  /// This is calculated by Flutter based on the font, font size, and content
  /// of the text.
  double get textWidth {
    return _paragraph?.maxIntrinsicWidth ?? 0;
  }

  /// Returns the [height] of the text in the paragraph, or `0` if the paragraph
  /// is null or has not been laid out.
  double get textHeight {
    return _paragraph?.height ?? 0;
  }

  /// Default text style used if no [painting.TextStyle] is provided.
  static painting.TextStyle defaultTextStyle = const painting.TextStyle(
    color: kColorBlack,
    decorationStyle: ui.TextDecorationStyle.solid,
  );

  /// The default [ui.ParagraphStyle] used in a [GText] if none is provided.
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

  /// Creates a new [GText] instance.
  ///
  /// The [text] parameter specifies the text that will be displayed.
  /// The [paragraphStyle] parameter specifies the paragraph style of the text.
  /// The [textStyle] parameter specifies the text style of the text.
  /// The [width] parameter specifies the width of the text.
  GText({
    String? text,
    ui.ParagraphStyle? paragraphStyle,
    painting.TextStyle? textStyle,
    double width = double.infinity,
  }) {
    painting.PaintingBinding.instance.systemFonts.addListener(_fontLoaded);
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

  /// Called when this [GText] instance is no longer needed and should be
  /// disposed of. This method also clears the Signals.
  @override
  void dispose() {
    super.dispose();
    painting.PaintingBinding.instance.systemFonts.removeListener(_fontLoaded);
    _onFontLoaded?.removeAll();
    _onFontLoaded = null;
  }

  /// Sets the [TextStyle] for the text.
  ///
  /// If the new style is the same as the current style, this method does nothing.
  /// Otherwise, the new style is assigned and the [GText] repainted.
  void setTextStyle(painting.TextStyle style) {
    if (_style == style) return;
    _style = style;
    _invalidBuilder = true;
  }

  /// Returns the text style used by the text.
  painting.TextStyle? getTextStyle() => _style;

  /// Returns the paragraph style used by the text.
  ui.ParagraphStyle? getParagraphStyle() => _paragraphStyle;

  /// Sets the [ParagraphStyle] for the text.
  ///
  /// If the new style is the same as the current style, this method does nothing.
  /// Otherwise, the new style is assigned and the [GText] repainted.
  void setParagraphStyle(ui.ParagraphStyle style) {
    if (_paragraphStyle == style) return;
    _paragraphStyle = style;
    _invalidBuilder = true;
  }

  /// Invalidates the current [ui.ParagraphBuilder] to be re-built next time it
  /// is accessed or when layout is called.
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

  // The [_layout] method is responsible for performing the layout of the text in
  /// the paragraph, based on the [width] of the [GText] and its paragraph constraints.
  /// The paragraph width is defined by [_width], which can be set by the user or
  /// calculated automatically based on the intrinsic width of the text. The
  /// [_maxTextWidthForWeb] constant is used as a maximum value for the paragraph
  /// width when the text is rendered on the web, where infinite widths may cause
  /// issues.
  ///
  /// After the layout is performed, the _invalidSize flag is set to false,
  /// indicating that the text layout is up-to-date.
  void _layout() {
    //// Web has a bug for double.infinity for text layout.
    final paragraphWidth = _width.isInfinite && !SystemUtils.usingSkia
        ? _maxTextWidthForWeb
        : _width;
    _paragraph?.layout(ui.ParagraphConstraints(width: paragraphWidth));
    _invalidSize = false;
  }

  /// Warning: Internal method.
  /// Applies the text's paint to the given canvas.
  ///
  /// If the [text] is empty, this method does nothing.
  ///
  /// If a [backgroundColor] is set, this method also draws a colored rectangle
  /// that spans the entire intrinsic width and height of the text.
  ///
  /// The text is drawn at the top-left corner of the text's bounds, which is
  /// affected by the text's transformation matrix and the target space.
  ///
  /// If the text's [alpha] is less than 1.0, the text is drawn with an alpha mask
  /// to prevent color bleeding. Otherwise, the text is drawn directly.
  @override
  void $applyPaint(ui.Canvas canvas) {
    super.$applyPaint(canvas);
    if (_text == '') return;
    validate();
    if (backgroundColor != null && backgroundColor!.alpha > 0) {
      canvas.drawRect(
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
        canvas.saveLayer(null, _alphaPaint);
        canvas.drawParagraph(_paragraph!, ui.Offset.zero);
        canvas.restore();
      } else {
        canvas.drawParagraph(_paragraph!, ui.Offset.zero);
      }
    }
  }

  /// Set the [alpha] value of this object and update the alpha value of the internal
  /// paint object that is used to render the text with the specified opacity.
  @override
  set alpha(double value) {
    final changed = value != $alpha;
    super.alpha = value;
    if (changed) {
      _alphaPaint.color = _alphaPaint.color.withOpacity($alpha);
    }
  }

  /// The intrinsic width of the text. If the width is set to [double.infinity],
  /// this value will be equal to the text width, otherwise it will be equal to
  /// the set width.
  double get intrinsicWidth => width == double.infinity ? textWidth : width;

  /// Validates the state of the [GText] object, checking if the builder needs to
  /// be updated, and if the size needs to be calculated. This method should be
  /// called before the object is rendered to ensure that the text is up-to-date
  /// and has the correct dimensions.
  ///
  /// If the builder is invalid, this method will rebuild it by creating a new
  /// [ui.ParagraphBuilder] with the current [_paragraphStyle] and [_style] and
  /// adding the current [_text] to it. The resulting [ui.Paragraph] will then be
  /// stored in the [_paragraph] property.
  ///
  /// If the size is invalid or the builder is invalid, this method will calculate
  /// the size of the text and store it in the [_width] and [_textHeight]
  /// properties. This is done by calling the [ui.Paragraph.layout] method with
  /// the width constraint set to the value of [_width].
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

  /// Creates a new [GText] object with the given properties and adds it to the
  /// specified [GDisplayObjectContainer] instance.
  ///
  /// The [text] argument is the text to be displayed. The [doc] argument is the
  /// display object container to which the text will be added. The [width] argument
  /// is the width of the text box, which defaults to double.infinity. If the
  /// [textAlign] argument is not [ui.TextAlign.left], the [width] argument must be
  /// specified.
  ///
  /// The remaining arguments correspond to properties of the
  /// [painting.TextStyle] and [ui.ParagraphStyle] classes. Refer to their
  /// respective documentation for more information.
  ///
  /// Returns the newly created [GText] instance.
  ///
  /// Throws an exception if [textAlign] is not [ui.TextAlign.left] and [width] is
  /// not specified.
  static GText build({
    String? text,
    GDisplayObjectContainer? doc,
    ui.Color? color,
    double width = double.infinity,
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
    if (width == double.infinity && textAlign != ui.TextAlign.left) {
      throw "[GText] To use $textAlign you need to specify the `width`";
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
      width: width,
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
