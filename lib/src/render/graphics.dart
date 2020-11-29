import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:graphx/graphx.dart';

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

  static final GxMatrix _helperMatrix = GxMatrix();

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

  Graphics beginBitmapFill(
    GTexture texture, [
    GxMatrix matrix,
    bool repeat = false,
    bool smooth = false,
  ]) {
    if (_holeMode) return this;
    final fill = Paint();
    fill.style = PaintingStyle.fill;
    fill.isAntiAlias = smooth;
    var tileMode = !repeat ? TileMode.clamp : TileMode.repeated;
    matrix ??= _helperMatrix;
    fill.shader = ImageShader(
      texture.root,
      tileMode,
      tileMode,
      matrix.toNative().storage,
    );
    _addFill(fill);
    _currentDrawing.shaderTexture = texture;
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

  // void drawImage(Image img) {}

  Graphics endFill() {
    if (_holeMode) {
      endHole();
    }
    _currentDrawing = GraphicsDrawingData(null, Path());
    return this;
  }

  Graphics lineStyle([
    double thickness = 0.0,
    int color = 0x0,
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

  /// For [GradientType.radial], `end` is used for [RadialGradient.focal], check
  /// the [RadialGradient] docs to understand the relation with [focalRadius]
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
    double radius = 0.5,
    double focalRadius = 0.0,
  ]) {
    final _colors = _GraphUtils.colorsFromHex(colors, alphas);
    if (type == GradientType.radial) {
      begin ??= Alignment.center;
      // end ??= Alignment.topRight;
    } else {
      begin ??= Alignment.topLeft;
      end ??= Alignment.topRight;
    }
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
        radius: radius,
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

  Graphics lineBitmapStyle(
    GTexture texture, [
    GxMatrix matrix,
    bool repeat = true,
    bool smooth = false,
  ]) {
    /// actual paint must be stroke.
    assert(_currentDrawing.fill.style == PaintingStyle.stroke);
    if (_holeMode) return this;
    final fill = _currentDrawing.fill;
    fill.isAntiAlias = smooth;
    var tileMode = !repeat ? TileMode.clamp : TileMode.repeated;
    matrix ??= _helperMatrix;
    fill.shader = ImageShader(
      texture.root,
      tileMode,
      tileMode,
      matrix.toNative().storage,
    );
    // _addFill(fill);
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
        Rect _bounds;
        if (graph.hasVertices) {
          _bounds = graph.vertices.getBounds();
        } else {
          _bounds = graph.path.getBounds();
        }
        fill.shader = graph.gradient.createShader(_bounds);
      } else {
        if (alpha != 1) {
          fill.color = baseColor.withOpacity(baseColor.opacity * alpha);
        }
      }

      if (graph.hasVertices) {
        if (graph.vertices.uvtData != null && graph.shaderTexture != null) {
          graph.vertices.calculateUvt(graph.shaderTexture);
        }
        var myPaint = Paint();
        myPaint.strokeWidth = 2;
        myPaint.color = Color(0xffff00ff);
        myPaint.style = PaintingStyle.stroke;

        if (fill.style == PaintingStyle.stroke) {
          canvas.drawRawPoints(PointMode.lines, graph.vertices.rawPoints, fill);
        } else {
          canvas.drawVertices(
            graph.vertices.rawData,
            graph.vertices.blendMode ?? BlendMode.src,
            fill,
          );
        }
      } else {
        canvas.drawPath(graph.path, fill);
      }

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

  /// Draw a bunch of triangles in the Canvas, only supports
  /// solid fill or image (not a stroke).
  /// Doesn't use a Path(), but drawVertices()...
  Graphics drawTriangles(
    List<double> vertices, [
    List<int> indices,
    List<double> uvtData,
    List<int> colors,
    BlendMode blendMode = BlendMode.src,
    Culling culling = Culling.positive,
  ]) {
    /// will only work if it has a fill.
    assert(_currentDrawing != null);
    assert(_currentDrawing.fill != null);
    _currentDrawing.vertices = _GraphVertices(VertexMode.triangles, vertices,
        indices, uvtData, colors, blendMode, culling);
    return this;
  }
}

class GraphicsDrawingData {
  Path path;
  Paint fill;

  Gradient gradient;
  Picture picture;
  bool isHole = false;

  /// for drawVertices()
  BlendMode blendMode = BlendMode.src;
  _GraphVertices vertices;

  /// temporal storage to use with _GraphVertices
  GTexture shaderTexture;

  bool get hasVertices => vertices != null;

  GraphicsDrawingData([this.fill, this.path]);

  bool get hasPicture => picture != null;

  bool get hasGradient => gradient != null;

  /// When cloning, we can pass fill and path by reference or make a deep copy.
  /// Mostly intended for direct `Graphics.pushData` and `Graphics.removeData`
  /// manipulation.
  GraphicsDrawingData clone([
    bool cloneFill = false,
    bool clonePath = false,
  ]) {
    final _fill = cloneFill ? fill?.clone() : fill;
    final _path = clonePath ? (path != null ? Path.from(path) : null) : path;
    final _vertices = vertices;
    return GraphicsDrawingData(_fill, _path)
      ..gradient = gradient
      ..picture = picture
      ..blendMode = blendMode
      ..vertices = _vertices;
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

class _GraphVertices {
  List<double> vertices, uvtData;
  List<double> adjustedUvtData;
  List<int> colors, indices;
  BlendMode blendMode;
  VertexMode mode;
  Path _path;
  Rect _bounds;
  bool _normalizedUvt;

  Float32List _rawPoints;
  Float32List get rawPoints {
    if (_rawPoints != null) return _rawPoints;
    var points = _GraphUtils.getTrianglePoints(this);
    _rawPoints = Float32List.fromList(points);
    return _rawPoints;
  }

  Culling culling;

  /// check if uvt requires normalization.
  _GraphVertices(
    this.mode,
    this.vertices, [
    this.indices,
    this.uvtData,
    this.colors,
    this.blendMode = BlendMode.src,
    this.culling = Culling.positive,
  ]) {
    _normalizedUvt = false;
    if (uvtData != null && uvtData.length > 6) {
      for (var i = 0; i < 6; ++i) {
        if (uvtData[i] <= 2.0) {
          _normalizedUvt = true;
        }
      }
      if (uvtData[uvtData.length - 2] <= 2.0 ||
          uvtData[uvtData.length - 1] <= 2.0) {
        _normalizedUvt = true;
      }
    }
  }

  void reset() {
    _path?.reset();
    _rawData = null;
    _bounds = null;
  }

  Rect getBounds() {
    if (_bounds != null) return _bounds;
    _bounds = computePath().getBounds();
    return _bounds;
  }

  Path computePath() {
    _path ??= _GraphUtils.getPathFromVertices(this);
    return _path;
  }

  Vertices _rawData;

  Vertices get rawData {
    if (_rawData != null) {
      return _rawData;
    }

    // calculateCulling();

    Float32List _textureCoordinates;
    Int32List _colors;
    Uint16List _indices;
    if (uvtData != null && adjustedUvtData != null) {
      _textureCoordinates = Float32List.fromList(adjustedUvtData);
    }
    if (colors != null) _colors = Int32List.fromList(colors);
    if (indices != null) _indices = Uint16List.fromList(indices);
    _rawData = Vertices.raw(
      VertexMode.triangles,
      Float32List.fromList(vertices),
      textureCoordinates: _textureCoordinates,
      colors: _colors,
      indices: _indices,
    );
    return _rawData;
  }

  void calculateUvt(GTexture shaderTexture) {
    if (uvtData == null) return;
    if (!_normalizedUvt) {
      adjustedUvtData = uvtData;
    } else {
      /// make a ratio of the image size
      var imgW = shaderTexture.width;
      var imgH = shaderTexture.height;
      adjustedUvtData = List<double>(uvtData.length);
      for (var i = 0; i < uvtData.length; i += 2) {
        adjustedUvtData[i] = uvtData[i] * imgW;
        adjustedUvtData[i + 1] = uvtData[i + 1] * imgH;
      }
    }
  }

  void calculateCulling() {
    var i = 0;
    var offsetX = 0.0, offsetY = 0.0;
    var ind = indices;
    var v = vertices;
    var l = indices.length;
    while (i < l) {
      var a_ = i;
      var b_ = i + 1;
      var c_ = i + 2;

      var iax = ind[a_] * 2;
      var iay = ind[a_] * 2 + 1;
      var ibx = ind[b_] * 2;
      var iby = ind[b_] * 2 + 1;
      var icx = ind[c_] * 2;
      var icy = ind[c_] * 2 + 1;

      var x1 = v[iax] - offsetX;
      var y1 = v[iay] - offsetY;
      var x2 = v[ibx] - offsetX;
      var y2 = v[iby] - offsetY;
      var x3 = v[icx] - offsetX;
      var y3 = v[icy] - offsetY;

      switch (culling) {
        case Culling.positive:
          if (!_GraphUtils.isCCW(x1, y1, x2, y2, x3, y3)) {
            i += 3;
            continue;
          }
          break;

        case Culling.negative:
          if (_GraphUtils.isCCW(x1, y1, x2, y2, x3, y3)) {
            i += 3;
            continue;
          }
          break;
        default:
          break;
      }

      /// todo: finish implementation.
      i += 3;
    }
  }
}

class _GraphUtils {
  static bool isCCW(
    double x1,
    double y1,
    double x2,
    double y2,
    double x3,
    double y3,
  ) =>
      ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)) < 0;

  static List<Color> colorsFromHex(List<int> colors, List<double> alphas) {
    final _colors = List<Color>(colors.length); //<Color>[];
    for (var i = 0; i < colors.length; ++i) {
      final a = (alphas != null && i < alphas.length ? alphas[i] : 1.0);
      _colors[i] = Color(colors[i]).withOpacity(a);
    }
    return _colors;
  }

  static final Path _helperPath = Path();

  static Path getPathFromVertices(_GraphVertices v) {
    var path = _helperPath;
    path.reset();
    var pos = v.vertices;
    var len = pos.length;
    final points = <Offset>[];
    for (var i = 0; i < len; i += 2) {
      points.add(Offset(pos[i], pos[i + 1]));
    }
    path.addPolygon(points, true);
    return path;
  }

  static List<double> getTrianglePoints(_GraphVertices v) {
    final output = <double>[];
    var ver = v.vertices;
    var ind = v.indices;
    if (ind == null) {
      /// calculate
      var len = ver.length;
      var out = List<double>(len * 2);
      var j = 0;
      for (var i = 0; i < len; i += 6) {
        out[j++] = ver[i + 0];
        out[j++] = ver[i + 1];
        out[j++] = ver[i + 2];
        out[j++] = ver[i + 3];
        out[j++] = ver[i + 2];
        out[j++] = ver[i + 3];
        out[j++] = ver[i + 4];
        out[j++] = ver[i + 5];
        out[j++] = ver[i + 4];
        out[j++] = ver[i + 5];
        out[j++] = ver[i + 0];
        out[j++] = ver[i + 1];
      }
      return out;
    } else {
      var len = ind.length;
      var out = List<double>(len * 4);
      var j = 0;
      for (var i = 0; i < len; i += 3) {
        var i0 = ind[i + 0];
        var i1 = ind[i + 1];
        var i2 = ind[i + 2];
        var v0 = i0 * 2;
        var v1 = i1 * 2;
        var v2 = i2 * 2;
        out[j++] = ver[v0];
        out[j++] = ver[v0 + 1];
        out[j++] = ver[v1];
        out[j++] = ver[v1 + 1];
        out[j++] = ver[v1];
        out[j++] = ver[v1 + 1];
        out[j++] = ver[v2];
        out[j++] = ver[v2 + 1];
        out[j++] = ver[v2];
        out[j++] = ver[v2 + 1];
        out[j++] = ver[v0];
        out[j++] = ver[v0 + 1];
      }
      return out;
    }
  }
}

enum Culling { negative, positive }
