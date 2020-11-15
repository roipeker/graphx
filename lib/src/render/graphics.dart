import 'dart:math';
import 'dart:ui';

import 'package:flutter/painting.dart';

import '../geom/geom.dart';
import '../utils/utils.dart';

enum GradientType {
  linear,
  radial,
}

class Graphics with RenderUtilMixin implements GxRenderable {
  final _drawingQueue = <GraphicsDrawingData>[];
  GraphicsDrawingData _currentDrawing = GraphicsDrawingData(null, Path());
  double alpha = 1;

  Graphics mask;

  bool isMask = false;

  Path get _path => _currentDrawing.path;

  static final Path stageRectPath = Path();
  static void updateStageRect(GxRect rect) {
    stageRectPath.reset();
    stageRectPath.addRect(rect.toNative());
  }

  void dispose() {
    mask = null;
    _drawingQueue?.clear();
    _currentDrawing = null;
  }

  List<GraphicsDrawingData> get drawingQueue => _drawingQueue;
  void copyFrom(Graphics other, [bool deepClone = false]) {
    _drawingQueue.clear();
    for (final command in other._drawingQueue) {
      _drawingQueue.add(command.clone(deepClone, deepClone));
    }
    mask = other.mask;
    alpha = other.alpha;
    _currentDrawing = other._currentDrawing?.clone();
  }

  /// Getting all paths bounds is more "accurate" when the object is rotated.
  /// cause it calculates each transformed matrix individually. But it has
  /// a bigger CPU hit.
  /// In [Graphics] "paths" are separated by [Paint] drawing commands:
  /// [beginFill()] and [lineStyle()]
  List<GxRect> getAllBounds([List<GxRect> out]) {
    out ??= <GxRect>[];
    _drawingQueue.forEach((e) {
      final pathRect = e?.path?.getBounds();
      if (pathRect == null) return;
      out.add(GxRect.fromNative(pathRect));
    });
    return out;
  }

  @override
  GxRect getBounds([GxRect out]) {
    Rect r;
    _drawingQueue.forEach((e) {
      final pathRect = e?.path?.getBounds();
      if (pathRect == null) return;
      if (r == null) {
        r = pathRect;
      } else {
        r = r.expandToInclude(pathRect);
      }
    });
    final result = r ?? Rect.zero;
    if (out == null) {
      out = GxRect.fromNative(result);
    } else {
      out.setTo(result.left, result.top, result.width, result.height);
    }
    return out;
  }

  bool hitTest(GxPoint localPoint, [bool useShape = false]) {
    if (useShape) {
      final point = Offset(
        localPoint.x,
        localPoint.y,
      );
      for (var e in _drawingQueue) {
        if (e.path.contains(point)) return true;
      }
      return false;
    } else {
//      return getBounds().contains(Offset(x, y));
      return getBounds().contains(
        localPoint.x,
        localPoint.y,
      );
    }
  }

  Graphics clear() {
    _drawingQueue.clear();
    _holeMode = false;
    _currentDrawing = GraphicsDrawingData(null, Path());
    return this;
  }

  Graphics beginFill(int color, [double alpha = 1]) {
    if (_holeMode) return this;
    final fill = Paint();
    fill.style = PaintingStyle.fill;
    fill.isAntiAlias = true;
    fill.color = Color(color).withOpacity(alpha.clamp(0.0, 1.0));
    _addFill(fill);
    return this;
  }

  Graphics drawPicture(Picture picture) {
    _drawingQueue.add(GraphicsDrawingData()..picture = picture);
    return this;
  }

  void drawImage(Image img) {}

  Graphics endFill() {
    if (_holeMode) {
      endHole();
    }
    _currentDrawing = GraphicsDrawingData(null, Path());
    return this;
  }

  Graphics lineStyle([
    double thickness = 0.0,
    int color,
    double alpha = 1.0,
    bool pixelHinting = true,
    StrokeCap caps,
    StrokeJoin joints,
    double miterLimit = 3.0,
  ]) {
    alpha ??= 1.0;
    alpha = alpha.clamp(0.0, 1.0);
    final paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Color(color).withOpacity(alpha);
    paint.strokeWidth = thickness;
    paint.isAntiAlias = pixelHinting;
    paint.strokeCap = caps ?? StrokeCap.butt;
    paint.strokeJoin = joints ?? StrokeJoin.miter;
    paint.strokeMiterLimit = miterLimit;
    _addFill(paint);
    return this;
  }

  Graphics beginGradientFill(
    GradientType type,
    List<int> colors, [
    List<double> alphas,
    List<double> ratios,
    Alignment begin,
    Alignment end,
    GradientTransform transform,
    Rect gradientBox,

    /// only radial
    double focalRadius = 1.0,
  ]) {
    final _colors = _GraphUtils.colorsFromHex(colors, alphas);
    begin ??= Alignment.topLeft;
    end ??= Alignment.topRight;
    Gradient _gradient;
    if (type == GradientType.linear) {
      _gradient = LinearGradient(
        colors: _colors,
        stops: ratios,
        begin: begin,
        end: end,
        tileMode: TileMode.clamp,
        transform: transform,
      );
    } else {
      _gradient = RadialGradient(
        center: begin,
        focal: end,
        radius: 0.5,
        colors: _colors,
        stops: ratios,
        tileMode: TileMode.clamp,
        focalRadius: focalRadius,
        transform: transform,
      );
    }

    final paint = Paint();
    paint.style = PaintingStyle.fill;
//    paint.isAntiAlias = true;
    _addFill(paint);
    if (gradientBox != null) {
      _currentDrawing.fill.shader = _gradient.createShader(gradientBox);
    } else {
      _currentDrawing.gradient = _gradient;
    }
    return this;
  }

  Graphics lineGradientStyle(
    List<int> colors, [
    List<double> alphas,
    List<double> ratios,
    GradientTransform transform,
    Rect gradientBox,
  ]) {
    /// actual paint must be stroke.
    assert(_currentDrawing.fill.style == PaintingStyle.stroke);
    final _colors = _GraphUtils.colorsFromHex(colors, alphas);
    final gradient = LinearGradient(
      colors: _colors,
      stops: ratios,
      tileMode: TileMode.clamp,
      transform: transform,
    );
    if (gradientBox != null) {
      _currentDrawing.fill.shader = gradient.createShader(gradientBox);
    } else {
      _currentDrawing.gradient = gradient;
    }
    return this;
  }

  Graphics moveTo(double x, double y) {
    _path.moveTo(x, y);
    return this;
  }

  Graphics lineTo(double x, double y) {
    _path.lineTo(x, y);
    return this;
  }

  Graphics closePath() {
    _path.close();
    return this;
  }

  Graphics cubicCurveTo(double controlX1, double controlY1, double controlX2,
      double controlY2, double anchorX, double anchorY) {
    _path.cubicTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
    return this;
  }

  Graphics curveTo(
      double controlX, double controlY, double anchorX, double anchorY) {
    _path.quadraticBezierTo(controlX, controlY, anchorX, anchorY);
    return this;
  }

  Graphics drawCircle(double x, double y, double radius) {
    final pos = Offset(x, y);
    final circ = Rect.fromCircle(center: pos, radius: radius);
    _path.addOval(circ);
    return this;
  }

  Graphics drawEllipse(double x, double y, double radiusX, double radiusY) {
    final pos = Offset(x, y);
    _path.addOval(
      Rect.fromCenter(
        center: pos,
        width: radiusX * 2,
        height: radiusY * 2,
      ),
    );
    return this;
  }

  Graphics drawGxRect(GxRect rect) {
    _path.addRect(rect.toNative());
    return this;
  }

  Graphics drawRect(double x, double y, double width, double height) {
    final r = Rect.fromLTWH(x, y, width, height);
    _path.addRect(r);
    return this;
  }

  Graphics drawRoundRectComplex(
    double x,
    double y,
    double width,
    double height, [
    double topLeftRadius = 0,
    double topRightRadius = 0,
    double bottomLeftRadius = 0,
    double bottomRightRadius = 0,
  ]) {
    _path.addRRect(
      RRect.fromLTRBAndCorners(
        x,
        y,
        x + width,
        y + height,
        topLeft: Radius.circular(topLeftRadius),
        topRight: Radius.circular(topRightRadius),
        bottomLeft: Radius.circular(bottomLeftRadius),
        bottomRight: Radius.circular(bottomRightRadius),
      ),
    );
    return this;
  }

  Graphics drawRoundRect(
    double x,
    double y,
    double width,
    double height,
    double ellipseWidth, [
    double ellipseHeight,
  ]) {
    final r = RRect.fromLTRBXY(x, y, x + width, y + height, ellipseWidth,
        ellipseHeight ?? ellipseWidth);
    _path.addRRect(r);
    return this;
  }

  Graphics drawPoly(List<GxPoint> points, [bool closePolygon = true]) {
    final len = points.length;
    final list = List<Offset>(len);
    for (var i = 0; i < len; ++i) {
      list[i] = points[i].toNative();
    }
    _path.addPolygon(list, true);
    return this;
  }

  void shiftPath(double x, double y, [bool modifyPreviousPaths = false]) {
    final offset = Offset(x, y);
    if (modifyPreviousPaths) {
      _drawingQueue.forEach((command) {
        command?.path = command?.path?.shift(offset);
      });
    } else {
      _currentDrawing?.path = _currentDrawing?.path?.shift(offset);
    }
  }

  Graphics arcOval(
    double cx,
    double cy,
    double radiusX,
    double radiusY,
    double startAngle,
    double sweepAngle,
  ) {
    _path.addArc(
      Rect.fromCenter(
          center: Offset(cx, cy), width: radiusX * 2, height: radiusY * 2),
      startAngle,
      sweepAngle,
    );
    return this;
  }

  Graphics arc(double cx, double cy, double radius, double startAngle,
      double sweepAngle) {
    if (sweepAngle == 0) return this;
//    _path.arcToPoint(arcEnd)
    _path.addArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: radius),
      startAngle,
      sweepAngle,
    );
    return this;
  }

  Graphics drawPolygonFaces(
    double x,
    double y,
    double radius,
    int sides, [
    double rotation = 0,
  ]) {
    final points = List<Offset>(sides);
    final rel = 2 * pi / sides;
    for (var i = 1; i <= sides; ++i) {
      final px = x + radius * cos(i * rel + rotation);
      final py = y + radius * sin(i * rel + rotation);
      points[i - 1] = Offset(px, py);
    }
    _path.addPolygon(points, true);
    return this;
  }

  Graphics drawStar(
    double x,
    double y,
    int points,
    double radius, [
    double innerRadius,
    double rotation = 0,
  ]) {
    innerRadius ??= radius / 2;
    final startAngle = (-1 * pi / 2) + rotation;
    final len = points * 2;
    final delta = pi * 2 / len;
    final polys = <Offset>[];
    for (var i = 0; i < len; ++i) {
      final r = i.isOdd ? innerRadius : radius;
      final a = i * delta + startAngle;
      polys.add(Offset(
        x + (r * cos(a)),
        y + (r * sin(a)),
      ));
    }
    _path.addPolygon(polys, true);
    return this;
  }

  bool _holeMode = false;

  Graphics beginHole() {
    if (_holeMode) return this;
    _holeMode = true;
    _currentDrawing = GraphicsDrawingData(null, Path())..isHole = true;
    return this;
  }

  /// finishes the current `beginHole()` command.
  /// When `applyToCurrentQueue` is true, the drawing commands of the "hole"
  /// will be applied to the current elements of the drawing queue (not
  /// including future ones), when `applyToCurrentQueue` is false, it will
  /// only cut the "holes" in the last drawing command.
  Graphics endHole([bool applyToCurrentQueue = false]) {
    _holeMode = false;
    // apply to previous elements.
    if (!_currentDrawing.isHole) {
      throw "Can't endHole() without starting a beginHole() command.";
//      return this;
    }
    final _holePath = _path;
    _holePath.close();
    _currentDrawing = _drawingQueue.last;
    if (!applyToCurrentQueue) {
      _currentDrawing.path = Path.combine(
        PathOperation.difference,
        _path,
        _holePath,
      );
    } else {
      for (final cmd in _drawingQueue) {
        cmd.path = Path.combine(
          PathOperation.difference,
          cmd.path,
          _holePath,
        );
      }
    }
    return this;
  }

  void paintWithFill(Canvas canvas, Paint fill) {
    if (!_isVisible) return;
    _drawingQueue.forEach((graph) {
      if (graph.hasPicture) {
        canvas.drawPicture(graph.picture);
        return;
      }
      canvas.drawPath(graph.path, fill);
    });
  }

  Path getPaths() {
    var output = Path();
    _drawingQueue.forEach((graph) {
      output = Path.combine(PathOperation.union, output, graph.path);
    });
    return output;
  }

  @override
  void paint(Canvas canvas) {
    // TODO : add mask support.
    if (isMask) {
      _drawingQueue.forEach((graph) {
        canvas.clipPath(graph.path, doAntiAlias: false);
      });
      return;
    }

    _constrainAlpha();
    if (!_isVisible) return;
    _drawingQueue.forEach((graph) {
      if (graph.hasPicture) {
        canvas.drawPicture(graph.picture);
        return;
      }
      final fill = graph.fill;
      final baseColor = fill.color;
      if (baseColor.alpha == 0) return;

      /// calculate gradient.
      if (graph.hasGradient) {
        final _bounds = graph.path.getBounds();
        fill.shader = graph.gradient.createShader(_bounds);
      } else {
        if (alpha != 1) {
          fill.color = baseColor.withOpacity(baseColor.opacity * alpha);
        }
      }
      canvas.drawPath(graph.path, fill);
      fill.color = baseColor;
    });
  }

  void _addFill(Paint fill) {
    /// same type, create path.
    Path path;
    if (_currentDrawing.isSameType(fill)) {
      path = Path();
    } else {
      path = _currentDrawing?.path;
    }
    _currentDrawing = GraphicsDrawingData(fill, path);
    _drawingQueue.add(_currentDrawing);
  }

  bool get _isVisible => alpha > 0.0 || _drawingQueue.isEmpty;

  /// push a custom GraphicsDrawingData into the commands list.
  /// this way you can use the low level APIs as you please.
  /// When set `asCurrent` to `true`, it will be used as the current
  /// `GraphicsDrawingData` and you can keep modifying the internal path
  /// with `Graphics` commands.
  /// This should be used only if you are operating with `Path` and `Paint`
  /// directly.
  /// `x` and `y` can shift the Path coordinates.
  void pushData(
    GraphicsDrawingData data, [
    bool asCurrent = false,
    double x,
    double y,
  ]) {
    if (x != null && y != null && data.path != null) {
      data.path = data.path.shift(Offset(x, y));
    }
    _drawingQueue.add(data);
    if (asCurrent) _currentDrawing = data;
  }

  /// removes the last `GraphicsDrawingData` from the drawing queue...
  /// This should be used only if you are operating with `Path` and `Paint`
  /// directly.
  GraphicsDrawingData popData() {
    return _drawingQueue.removeLast();
  }

  /// removes, if enqueued, the specified `GraphicsDrawingData` instance from
  /// the drawing queue list.
  /// This should be used only if you are operating with `Path` and `Paint`
  /// directly.
  void removeData(GraphicsDrawingData data) {
    _drawingQueue.remove(data);
  }

  void _constrainAlpha() {
    alpha = alpha.clamp(0.0, 1.0);
  }

  /// Appends a native `Path` to the current drawing path,
  /// `x` and `y` can offset the target position, while `transform` can be used
  /// to rotated, scale, translate, the given shape.
  Graphics drawPath(Path path,
      [double x = 0, double y = 0, GxMatrix transform]) {
    _path.addPath(
      path,
      Offset(x, y),
      matrix4: transform?.toNative()?.storage,
    );
    return this;
  }
}

class GraphicsDrawingData {
  Path path;
  Paint fill;

  Gradient gradient;
  Picture picture;
  bool isHole = false;

  GraphicsDrawingData([this.fill, this.path]);

  bool get hasPicture => picture != null;

  bool get hasGradient => gradient != null;

  /// When cloning, we can pass fill and path by reference or make a deep copy.
  /// Mostly intended for direct `Graphics.pushData` and `Graphics.removeData`
  /// manipulation.
  GraphicsDrawingData clone([bool cloneFill = false, bool clonePath = false]) {
    final _fill = cloneFill ? fill?.clone() : fill;
    final _path = clonePath ? (path != null ? Path.from(path) : null) : path;
    return GraphicsDrawingData(_fill, _path)
      ..gradient = gradient
      ..picture = picture;
  }

  bool isSameType(Paint otherFill) {
    return fill?.style == otherFill?.style ?? false;
  }
// compute grad?
}

extension ExtSkiaPaintCustom on Paint {
  Paint clone([Paint out]) {
    out ??= Paint();
    out.maskFilter = maskFilter;
    out.blendMode = blendMode;
    out.color = color;
    out.style = style;
    out.colorFilter = colorFilter;
    out.filterQuality = filterQuality;
    out.imageFilter = imageFilter;
    out.invertColors = invertColors;
    out.isAntiAlias = isAntiAlias;
    out.shader = shader;
    out.strokeCap = strokeCap;
    out.strokeJoin = strokeJoin;
    out.strokeMiterLimit = strokeMiterLimit;
    out.strokeWidth = strokeWidth;
    return out;
  }
}

class _GraphUtils {
  static List<Color> colorsFromHex(List<int> colors, List<double> alphas) {
    final _colors = List<Color>(colors.length); //<Color>[];
    for (var i = 0; i < colors.length; ++i) {
      final a = (alphas != null && i < alphas.length ? alphas[i] : 1.0);
      _colors[i] = Color(colors[i]).withOpacity(a);
    }
    return _colors;
  }
}
