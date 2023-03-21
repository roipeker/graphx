import 'dart:ui';

import '../../graphx.dart';

/// A display object that renders an SVG image.
///
/// The image is drawn from the [SvgData] object passed in the constructor.
/// If the [SvgData] is null, this object will not draw anything.
class GSvgShape extends GDisplayObject {
  /// A [GMatrix] helper object used for transformations
  static final GMatrix _sHelperMatrix = GMatrix();

  /// A [GPoint] helper object used for transformation coordinates
  static final GPoint _sHelperPoint = GPoint();

  /// The color to be applied to the SVG shape as a tint.
  /// If null, no tint will be applied.
  Color? _tint;

  /// The blend mode that will be used to blend the SVG image.
  /// play nice with Colorization (or modulate).
  BlendMode _blendMode = BlendMode.srcATop;

  /// A flag that indicates if the tint or blend mode has changed and requires
  /// a redraw to update the canvas.
  bool _invalidColor = false;

  /// A flag that indicates if the SVG image data is valid and can be drawn.
  bool _isValid = false;

  /// The SVG image data to be drawn.
  SvgData? _data;

  /// The paint object used to draw the SVG image.
  final _paint = Paint();

  /// Indicates whether the GSvgShape should use a [Paint] object to render.
  /// When set to true, it will apply the tint and blend mode to the paint
  /// object, otherwise it will ignore these values and use the default paint
  /// configuration.
  bool usePaint = false;

  /// Creates a new [GSvgShape] object that renders an SVG image.
  ///
  /// The [data] parameter is optional. If provided, it will be used as the
  /// source of the SVG image to draw. If it's null, nothing will be drawn until
  /// a valid [SvgData] is assigned to this object.
  GSvgShape(SvgData? data) {
    this.data = data;
  }

  /// Sets the transparency of the shape and updates the paint color with the
  /// new alpha value.
  @override
  set alpha(double value) {
    super.alpha = value;
    _paint.color = _paint.color.withOpacity($alpha);
  }

  /// The blending mode to use when drawing the SVG image.
  BlendMode get blendMode {
    return _blendMode;
  }

  /// Sets the blend mode that will be used to blend the SVG image.
  set blendMode(BlendMode value) {
    _blendMode = value;
    _invalidColor = true;
    usePaint = true;
    requiresRedraw();
  }

  /// The [SvgData] object that contains the SVG image to draw.
  ///
  /// If this value is null, nothing will be drawn.
  SvgData? get data {
    return _data;
  }

  /// Sets the SVG image data to be drawn.
  set data(SvgData? data) {
    if (_data == data) {
      return;
    }
    _data = data;
    _isValid = _data?.hasContent ?? false;
    requiresRedraw();
  }

  /// Returns the native paint object used to draw the SVG image.
  Paint get nativePaint => _paint;

  /// Returns the current tint color applied to the SVG image.
  Color? get tint {
    return _tint;
  }

  /// Sets the tint color that will be applied to the SVG image.
  set tint(Color? value) {
    _tint = value;
    _invalidColor = true;
    usePaint = true;
    requiresRedraw();
  }

  /// (Internal usage)
  /// Applies the paint settings to the canvas.
  @override
  void $applyPaint(Canvas? canvas) {
    var doSaveLayer = $alpha != 1 || usePaint;
    if (doSaveLayer) {
      if (_invalidColor) _validateColor();
      final rect = getBounds(this)!.toNative();
      canvas!.saveLayer(rect, _paint);
    }
    canvas!.drawPicture(_data!.picture!);
    if (doSaveLayer) {
      canvas.restore();
    }
  }

  /// Creates a new [GSvgShape] object that is a copy of this one.
  ///
  /// The returned [GSvgShape] will have the same [data] and properties as this one.
  GSvgShape clone() {
    var obj = GSvgShape(data);
    obj._blendMode = _blendMode;
    obj._tint = _tint;
    obj.$alpha = $alpha;
    obj.transformationMatrix = transformationMatrix;
    return obj;
  }

  /// Calculates the bounds of the shape in the coordinate system of the target
  /// object.
  @override
  GRect? getBounds(GDisplayObject? targetSpace, [GRect? out]) {
    final matrix = _sHelperMatrix;
    matrix.identity();
    getTransformationMatrix(targetSpace, matrix);
    if (_isValid) {
      var r = _data!.size;
      out = MatrixUtils.getTransformedBoundsRect(
        matrix,
        r,
        out,
      );
    } else {
      matrix.transformCoords(0, 0, _sHelperPoint);
      out!.setTo(_sHelperPoint.x, _sHelperPoint.y, 0, 0);
    }
    return out;
  }

  /// Draws the shape on the given canvas.
  @override
  void paint(Canvas canvas) {
    if (!_isValid) return;
    super.paint(canvas);
  }

  /// Returns a string representation of the object.
  @override
  String toString() {
    final msg = name != null ? ' {name: $name}' : '';
    return '$runtimeType (SvgShape)$msg';
  }

  /// Validates the [_tint] and [_blendMode] properties and sets [_invalidColor]
  /// to false. This is used internally in the $applyPaint method when the
  /// [_paint] needs to be updated.
  void _validateColor() {
    _paint.colorFilter = ColorFilter.mode(_tint!, _blendMode);
    _invalidColor = false;
  }
}

/// A proxy class to the package `flutter_svg`.
class SvgData {
  /// The color of the SVG. If null, the original color will be used.
  Color? color;

  /// The viewBox of the SVG.
  GRect? viewBox;

  /// The size of the SVG.
  late GRect size;

  /// The [Picture] object containing the SVG data.
  Picture? picture;

  /// Indicates whether the [SvgData] has valid content or not.
  bool? hasContent;

  /// Creates a new [SvgData] object with optional [picture].
  SvgData([this.picture]);

  /// Dispose the [SvgData] object by releasing the [Picture] instance and setting
  /// the [hasContent] flag to false.
  void dispose() {
    picture?.dispose();
    picture = null;
    hasContent = false;
  }
}
