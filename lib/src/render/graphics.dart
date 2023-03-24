import 'dart:ui' as ui;

import 'package:flutter/painting.dart';

import '../../graphx.dart';
import 'graphics_utils.dart';

/// An enumeration that defines the culling behavior for [GraphicsVertices]
/// elements.
enum Culling {
  /// Specifies that triangles should be culled based on clockwise winding
  /// order.
  negative,

  /// Specifies that triangles should be culled based on counter-clockwise
  /// winding order.
  positive,
}

/// An enumeration of different types of gradients that can be applied to a [Graphics] object.
enum GradientType {
  /// A linear gradient, where the colors blend from one point to another in a straight line.
  linear,

  /// A radial gradient, where the colors blend from the center point outwards in a circular pattern.
  radial,

  /// A sweep gradient, where the colors blend around a central point in a circular pattern.
  sweep,
}

/// A class representing graphics, shapes, and vector drawings that can be
/// rendered by Flutter.
///
/// This class provides a series of methods for drawing various shapes,
/// setting fill and stroke styles, applying gradients, and applying masks.
/// It also supports hit testing and retrieving the bounding boxes of the
/// drawn shapes.
/// It should not be instantiated, use a [GShape.graphics] or [GSprite.graphics]
/// instead
class Graphics with RenderUtilMixin {
  /// A helper [GMatrix] used for creating shaders and gradients.
  static final GMatrix _helperMatrix = GMatrix();

  /// (Internal usage)
  /// Utility method to get the path representing the stage rectangle.
  static final Path stageRectPath = Path();

  /// A queue of drawing commands represented by instances of
  /// [GraphicsDrawingData].
  final _drawingQueue = <GraphicsDrawingData?>[];

  /// The current [GraphicsDrawingData] that is being drawn.
  GraphicsDrawingData? _currentDrawing = GraphicsDrawingData(null, Path());

  /// The global alpha value for the graphics object, ranging from 0 to 1.
  double alpha = 1.0;

  /// The [Graphics] object used as a mask for this object.
  Graphics? mask;

  /// A flag to indicate whether this object is a mask.
  bool isMask = false;

  /// Indicates if the graphics object is currently in hole mode or not. When in
  /// hole mode, drawing operations create "holes" in the shapes instead of
  /// rendering new shapes.
  bool _holeMode = false;

  /// Returns the drawing queue as a list of [GraphicsDrawingData?].
  List<GraphicsDrawingData?> get drawingQueue {
    return _drawingQueue;
  }

  // TODO: should we avoid rendering if alpha=0 ?
  // It prevents bounding box calculation.
  bool get _isVisible {
    return alpha > 0.0 || _drawingQueue.isEmpty;
  }

  /// The current path being drawn.
  Path? get _path {
    return _currentDrawing!.path;
  }

  /// Draws an arc of a circle.
  ///
  /// The circle is specified by its center [cx], [cy]  and [radius]. The arc
  /// starts at [startAngle] and sweeps [sweepAngle] degrees (in radians).
  ///
  /// If [moveTo] is true, the path will start at the beginning of the arc
  /// instead of connecting it to the previous path.
  ///
  /// See also:
  ///
  ///  * [Path.arcTo], the method used to draw the arc.
  ///  * [Path.addArc], the method used to add the arc to the current path.
  Graphics arc(
    double cx,
    double cy,
    double radius,
    double startAngle,
    double sweepAngle, [
    bool moveTo = false,
  ]) {
    if (sweepAngle == 0) {
      return this;
    }
    if (!moveTo) {
      _path!.arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle,
        sweepAngle,
        false,
      );
    } else {
      _path!.addArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: radius),
        startAngle,
        sweepAngle,
      );
    }
    return this;
  }

  /// Draws an arc of an oval.
  ///
  /// The oval is specified by its center `(cx, cy)`, x radius [radiusX], and y
  /// radius [radiusY]. The arc starts at [startAngle] and sweeps [sweepAngle]
  /// degrees (in radians).
  ///
  /// See also:
  ///
  ///  * [Path.addArc], the method used to draw the arc.
  Graphics arcOval(
    double cx,
    double cy,
    double radiusX,
    double radiusY,
    double startAngle,
    double sweepAngle,
  ) {
    _path!.addArc(
      Rect.fromCenter(
        center: Offset(cx, cy),
        width: radiusX * 2,
        height: radiusY * 2,
      ),
      startAngle,
      sweepAngle,
    );
    return this;
  }

  /// Draws an arc from the current point to a given point.
  ///
  /// The arc has [radius] and is tangent to the line from the current point to
  /// ([endX], [endY]).
  ///
  /// If [relativeMoveTo] is true, the current point is moved to the endpoint of
  /// the arc.
  ///
  /// See also:
  ///
  ///  * [Path.arcToPoint], the method
  Graphics arcToPoint(
    double endX,
    double endY,
    double radius, [
    double rotation = 0.0,
    bool largeArc = false,
    bool clockwise = true,
    bool relativeMoveTo = false,
  ]) {
    if (radius == 0) {
      return this;
    }
    if (relativeMoveTo) {
      _path!.arcToPoint(
        Offset(endX, endY),
        radius: Radius.circular(radius),
        clockwise: clockwise,
        largeArc: largeArc,
        rotation: rotation,
      );
    } else {
      _path!.relativeArcToPoint(
        Offset(endX, endY),
        radius: Radius.circular(radius),
        clockwise: clockwise,
        largeArc: largeArc,
        rotation: rotation,
      );
    }
    return this;
  }

  /// Begins filling a shape with the specified bitmap [texture].
  ///
  /// If [_holeMode] is true, the method will do nothing and return this
  /// [Graphics] object.
  ///
  /// If [repeat] is `false`, the bitmap is only used once to fill the shape.
  ///
  /// If [smooth] is `true`, the method applies anti-aliasing to the bitmap.
  ///
  /// Returns this [Graphics] object after beginning the fill.
  Graphics beginBitmapFill(
    GTexture texture, [
    GMatrix? matrix,
    bool repeat = false,
    bool smooth = false,
  ]) {
    if (_holeMode) {
      return this;
    }
    final fill = Paint();
    fill.style = PaintingStyle.fill;
    fill.isAntiAlias = smooth;
    var tileMode = !repeat ? TileMode.clamp : TileMode.repeated;
    matrix ??= _helperMatrix;
    fill.shader = ImageShader(
      texture.root!,
      tileMode,
      tileMode,
      matrix.toNative().storage,
    );
    _addFill(fill);
    _currentDrawing!.shaderTexture = texture;
    return this;
  }

  /// Begins filling a shape with the specified [color].
  ///
  /// If [_holeMode] is true, the method will do nothing and return this
  /// [Graphics] object.
  ///
  /// If [antiAlias] is `true`, the method applies anti-aliasing to the fill.
  ///
  /// Returns this [Graphics] object after beginning the fill.
  Graphics beginFill(Color color, [bool antiAlias = true]) {
    if (_holeMode) {
      return this;
    }
    final fill = Paint();
    fill.style = PaintingStyle.fill;
    fill.isAntiAlias = antiAlias;
    fill.color = color;
    _addFill(fill);
    return this;
  }

  /// Begins filling a shape with the specified gradient.
  ///
  /// If [_holeMode] is true, the method will do nothing and return this
  /// [Graphics] object.
  ///
  /// If [ratios] is not specified, the method creates an equal distribution of
  /// color across the gradient.
  ///
  /// If [begin] is not specified, the method uses [Alignment.center].
  ///
  /// If [end] is not specified, the method uses [Alignment.centerRight].
  ///
  /// If [rotation] is not specified, the method uses `0.0`.
  ///
  /// If [tileMode] is not specified, the method uses [TileMode.clamp].
  ///
  /// If [gradientBox] is specified, the method uses it to create a gradient
  /// shader that matches the bounding box of the object.
  ///
  /// If [radius] is not specified, the method uses `0.5`.
  ///
  /// If [focalRadius] is not specified, the method uses `0.0`.
  ///
  /// If [sweepStartAngle] is not specified, the method uses `0.0`.
  ///
  /// If [sweepEndAngle] is not specified, the method uses `6.2832`.
  ///
  /// Returns this [Graphics] object after beginning the gradient fill. For
  /// [GradientType.radial], `end` is used for [RadialGradient.focal], check the
  /// [RadialGradient] docs to understand the relation with [focalRadius]
  Graphics beginGradientFill(
    GradientType type,
    List<Color> colors, {
    List<double>? ratios,
    Alignment? begin,
    Alignment? end,
    double rotation = 0,
    TileMode tileMode = TileMode.clamp,
    Rect? gradientBox,

    /// only radial
    double radius = 0.5,
    double focalRadius = 0.0,

    /// only sweep
    double sweepStartAngle = 0.0,
    double sweepEndAngle = 6.2832,
  }) {
    final gradient = _createGradient(
      type,
      colors,
      ratios,
      begin,
      end,
      rotation,
      radius,
      focalRadius,
      sweepStartAngle,
      sweepEndAngle,
      tileMode,
    );
    final paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.isAntiAlias = true;
    _addFill(paint);
    if (gradientBox != null) {
      _currentDrawing!.fill!.shader = gradient.createShader(gradientBox);
    } else {
      _currentDrawing!.gradient = gradient;
    }
    return this;
  }

  /// Set the graphics object into a "hole mode". All subsequent shapes will be
  /// treated as holes instead of being filled with the current paint. Call
  /// [endHole] to exit hole mode.
  Graphics beginHole() {
    if (_holeMode) return this;
    _holeMode = true;
    _currentDrawing = GraphicsDrawingData(null, Path())..isHole = true;
    return this;
  }

  /// Begins filling a shape with the specified raw [paint] instance.
  ///
  /// If [_holeMode] is true, the method will do nothing and return this
  /// [Graphics] object.
  ///
  /// Returns this [Graphics] object after beginning the fill.
  Graphics beginPaint(Paint paint) {
    if (_holeMode) {
      return this;
    }
    _addFill(paint);
    return this;
  }

  /// Begins filling a shape with the specified [shader].
  ///
  /// If [_holeMode] is true, the method will do nothing and return this
  /// [Graphics] object.
  ///
  /// Returns this [Graphics] object after beginning the fill.
  Graphics beginShader(Shader shader) {
    if (_holeMode) {
      return this;
    }
    final fill = Paint();
    if (shader is DisplayShader) {
      assert(shader.shader != null);
      shader = shader.shader!;
    }
    fill.shader = shader;
    _addFill(fill);
    return this;
  }

  /// Applies [blendMode] to the current drawing fill (or stroke).
  ///
  /// If [_holeMode] is true, the method will do nothing and return this
  /// [Graphics] object.
  ///
  /// Returns this [Graphics] object after setting the blend mode.
  Graphics blendMode(ui.BlendMode blendMode) {
    if (_holeMode) {
      return this;
    }
    _currentDrawing?.fill?.blendMode = blendMode;
    return this;
  }

  /// Removes all strokes and fills.
  ///
  /// Returns this [Graphics] object after clearing the drawing queue.
  Graphics clear() {
    _drawingQueue.clear();
    _holeMode = false;
    _currentDrawing = GraphicsDrawingData(null, Path());
    return this;
  }

  /// Closes the current sub-path by drawing a straight line to the starting
  /// point of the sub-path.
  Graphics closePath() {
    _path!.close();
    return this;
  }

  /// Quick way to colorize all previous drawing.
  /// Applies a [color] filter to all fills in the drawingQueue.
  ///
  /// This method modifies the colorFilter property of the Paint object
  /// associated with each fill in the drawingQueue.
  ///
  /// The colorFilter applies a color to the fill while preserving the
  /// transparency of the original fill. This allows for easy color changes of
  /// shapes drawn by this [Graphics] object without modifying the original
  /// [Paint]
  void colorize(Color color) {
    for (var dq in drawingQueue) {
      if (dq?.fill != null) {
        dq?.fill?.colorFilter = ColorFilter.mode(color, BlendMode.srcATop);
      }
    }
  }

  /// Draws a conic Bezier curve from the current drawing position to the
  /// specified anchor point ([anchorX], [anchorY]), using the specified control
  /// point([controlX], [controlY]) and [weight].
  ///
  /// If [relative] is true, the curve is drawn relative to the current position.
  ///
  /// A conic Bezier curve is a quadratic Bezier curve that has a "weight"
  /// parameter that controls how much the curve bends. The curve is defined by
  /// a control point that determines the direction and magnitude of the curve's
  /// bend. See also:
  ///
  /// * [Path.conicTo], which is used to draw a conic curve in a [Path].
  /// * [Path.quadraticBezierTo], which is used to draw a quadratic Bezier curve.
  /// * [cubicCurveTo], which is used to draw a cubic Bezier curve.
  ///
  /// The method returns this, which allows for method chaining.
  Graphics conicCurveTo(
    double controlX,
    double controlY,
    double anchorX,
    double anchorY,
    double weight, [
    bool relative = false,
  ]) {
    if (!relative) {
      _path!.conicTo(controlX, controlY, anchorX, anchorY, weight);
    } else {
      _path!.relativeConicTo(controlX, controlY, anchorX, anchorY, weight);
    }
    return this;
  }

  /// Copies the drawing data from the [other], [Graphics] object.
  ///
  /// If [deepClone] is true, it performs a deep clone of the drawing data,
  /// otherwise, it performs a shallow clone.
  void copyFrom(Graphics other, [bool deepClone = false]) {
    _drawingQueue.clear();
    for (final command in other._drawingQueue) {
      _drawingQueue.add(command!.clone(deepClone, deepClone));
    }
    mask = other.mask;
    alpha = other.alpha;
    _currentDrawing = other._currentDrawing?.clone();
  }

  // Draws a cubic Bezier curve from the current drawing position to the specified
  /// anchor point ([anchorX], [anchorY]), using the specified control points
  /// ([controlX1], [controlY1]) and ([controlX2], [controlY2]).
  ///
  /// The curve starts at the current point in the path and ends at ([anchorX], [anchorY]).
  /// The two control points determine the shape of the curve.
  ///
  /// The method returns this, which allows for method chaining.
  Graphics cubicCurveTo(
    double controlX1,
    double controlY1,
    double controlX2,
    double controlY2,
    double anchorX,
    double anchorY,
  ) {
    _path!
        .cubicTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
    return this;
  }

  /// Draws a quadratic Bezier curve from the current drawing position to the
  /// specified anchor point ([anchorX], [anchorY]), using the specified control
  /// point ([controlX], [controlY]).
  ///
  /// The method returns this, which allows for method chaining.
  Graphics curveTo(
    double controlX,
    double controlY,
    double anchorX,
    double anchorY,
  ) {
    _path!.quadraticBezierTo(controlX, controlY, anchorX, anchorY);
    return this;
  }

  /// Disposes the graphics object, clearing the drawing queue and mask.
  void dispose() {
    mask = null;
    _drawingQueue.clear();
    _currentDrawing = null;
  }

  /// Draws a circle with the given [radius] centered at ([x], [y]).
  ///
  /// The circle is added to the current path as an oval with width and height
  /// equal to radius * 2 and the center at the specified coordinates.
  ///
  /// The method returns this, which allows for method chaining.
  Graphics drawCircle(double x, double y, double radius) {
    _path!.addOval(
      Rect.fromCircle(center: Offset(x, y), radius: radius),
    );
    return this;
  }

  /// Draws an ellipse centered at the specified coordinates and with the given
  /// radii.
  ///
  /// The [x] and [y] parameters specify the center of the ellipse. The
  /// [radiusX] parameter specifies the radius of the ellipse in the horizontal
  /// direction, and the [radiusY] parameter specifies the radius of the ellipse
  /// in the vertical direction.
  ///
  /// The resulting ellipse is contained within the rectangle whose top-left
  /// corner is at `(x - radiusX, y - radiusY)` and whose size is `(radiusX * 2,
  /// radiusY * 2)`.
  ///
  /// This method adds the ellipse to the current path and  returns this, which
  /// allows for method chaining.
  Graphics drawEllipse(double x, double y, double radiusX, double radiusY) {
    _path!.addOval(
      Rect.fromCenter(
        center: Offset(x, y),
        width: radiusX * 2,
        height: radiusY * 2,
      ),
    );
    return this;
  }

  /// Draws a rectangle using the specified [GRect].
  ///
  /// The [rect] parameter is a [GRect] object that defines the position and
  /// size of the rectangle to be drawn.
  ///
  /// The method returns this, which allows for method chaining.
  Graphics drawGRect(GRect rect) {
    _path!.addRect(rect.toNative());
    return this;
  }

  /// Appends a native [path] to the current drawing path, as [x] and [y] can
  /// offset the target position, while [transform] can be used to rotated,
  /// scale, translate, the given shape.
  ///
  /// The method returns this, which allows for method chaining.
  Graphics drawPath(
    Path path, [
    double x = 0,
    double y = 0,
    GMatrix? transform,
  ]) {
    _path!.addPath(
      path,
      Offset(x, y),
      matrix4: transform?.toNative().storage,
    );
    return this;
  }

  /// Adds a [picture] to the list of drawings commands to render.
  ///
  /// The method returns this, which allows for method chaining.
  Graphics drawPicture(ui.Picture picture) {
    _drawingQueue.add(GraphicsDrawingData()..picture = picture);
    return this;
  }

  /// Draws a complex polygon from a List of [points] that contains the vertices
  /// of the polygon Is similar to use [moveTo] and [lineTo] methods but in one
  /// command. [closePolygon] will close the shape, defaults to `true`.
  ///
  /// The method returns this, which allows for method chaining.
  ///
  /// See also:
  ///
  ///  * [Path.addPolygon], the method used to draw the polygon.
  Graphics drawPoly(List<GPoint> points, [bool closePolygon = true]) {
    final len = points.length;
    final list = List<Offset>.filled(len, Offset.zero);
    for (var i = 0; i < len; ++i) {
      list[i] = points[i].toNative();
    }
    _path!.addPolygon(list, closePolygon);
    return this;
  }

  /// Draws a polygon with faces of equal size from the center point `(x, y)` to
  /// the circumference with a specified number of [sides]. The [radius] of the
  /// polygon can also be specified, along with an optional [rotation] angle.
  ///
  /// The method returns this, which allows for method chaining.
  Graphics drawPolygonFaces(
    double x,
    double y,
    double radius,
    int sides, [
    double rotation = 0,
  ]) {
    final points = List<Offset>.filled(sides, Offset.zero);
    final rel = 2 * Math.PI / sides;
    for (var i = 1; i <= sides; ++i) {
      points[i - 1] = Offset(
        x + radius * Math.cos(i * rel + rotation),
        y + radius * Math.sin(i * rel + rotation),
      );
    }
    _path!.addPolygon(points, true);
    return this;
  }

  /// Draws a rectangle using the specified coordinates and dimensions.
  ///
  /// The rectangle is drawn starting from the top-left point ([x], [y]) and
  /// with the specified [width] and [height].
  ///
  /// Returns the current [Graphics] instance, allowing for method chaining.
  Graphics drawRect(double x, double y, double width, double height) {
    _path!.addRect(
      Rect.fromLTWH(x, y, width, height),
    );
    return this;
  }

  /// Draws a rounded rectangle with the same radius on all corners.
  ///
  /// The rectangle starts at position ([x], [y]) and has the given [width] and
  /// [height]. The [ellipseWidth] and [ellipseHeight] parameters specify the x
  /// and y radii of the ellipse used to round the corners. If [ellipseHeight]
  /// is not provided, it defaults to [ellipseWidth].
  ///
  /// Returns the current [Graphics] instance, allowing for method chaining.
  ///
  /// See also:
  ///
  ///  * [RRect], the underlying class used to draw the rounded rectangle.
  Graphics drawRoundRect(
    double x,
    double y,
    double width,
    double height,
    double ellipseWidth, [
    double? ellipseHeight,
  ]) {
    _path!.addRRect(
      RRect.fromLTRBXY(
        x,
        y,
        x + width,
        y + height,
        ellipseWidth,
        ellipseHeight ?? ellipseWidth,
      ),
    );
    return this;
  }

  /// Draws a rounded rectangle with different corner radii.
  ///
  /// The rectangle starts at position ([x], [y]) and has the given [width] and
  /// [height]. The corner radii can be specified for each corner using the
  /// respective parameters.
  ///
  /// Returns the current [Graphics] instance, allowing for method chaining.
  ///
  /// See also:
  ///
  ///  * [RRect], the underlying class used to draw the rounded rectangle.
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
    _path!.addRRect(
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

  /// Draws a star polygon with a given number of [points] and [radius] from the
  /// center point ([x], [y]). An optional [innerRadius] can be specified to
  /// create a star shape. The star can also be rotated by [rotation] angle
  /// (defaults to `0`).
  ///
  /// Returns the current [Graphics] instance, allowing for method chaining.
  Graphics drawStar(
    double x,
    double y,
    int points,
    double radius, [
    double? innerRadius,
    double rotation = 0,
  ]) {
    innerRadius ??= radius / 2;
    final startAngle = (-1 * Math.PI1_2) + rotation;
    final len = points * 2;
    final delta = Math.PI_2 / len;
    final polys = <Offset>[];
    for (var i = 0; i < len; ++i) {
      final r = i.isOdd ? innerRadius : radius;
      final a = i * delta + startAngle;
      polys.add(Offset(
        x + (r * Math.cos(a)),
        y + (r * Math.sin(a)),
      ));
    }
    _path!.addPolygon(polys, true);
    return this;
  }

  /// (Warning: Experimental and buggy)
  ///
  /// Draw a bunch of triangles in the Canvas, only supports solid fill or image
  /// (not a stroke). Doesn't use a Path(), but drawVertices() instead.
  ///
  /// Returns the current [Graphics] instance, allowing for method chaining.
  Graphics drawTriangles(
    List<double> vertices, [
    List<int>? indices,
    List<double>? uvtData,
    List<int>? hexColors,
    BlendMode? blendMode = BlendMode.src,
    Culling culling = Culling.positive,
  ]) {
    /// will only work if it has a fill.
    assert(_currentDrawing != null);
    assert(_currentDrawing!.fill != null);
    _currentDrawing!.vertices = GraphicsVertices(
      ui.VertexMode.triangles,
      vertices,
      indices,
      uvtData,
      hexColors,
      blendMode,
      culling,
    );
    return this;
  }

  /// Ends the current fill.
  ///
  /// If [_holeMode] is true, the method will call [endHole] instead of creating
  /// a new drawing data object.
  ///
  /// Returns this [Graphics] object after ending the fill.
  Graphics endFill() {
    if (_holeMode) {
      endHole();
    }
    _currentDrawing = GraphicsDrawingData(null, Path());
    return this;
  }

  /// Finishes the current [beginHole] command. When [applyToCurrentQueue] is
  /// true, the drawing commands of the "hole" will be applied to the current
  /// elements of the drawing queue (not including future ones), when
  /// [applyToCurrentQueue] is false, it will only cut the "holes" in the last
  /// drawing command.
  ///
  /// Returns the current [Graphics] instance, allowing for method chaining.
  Graphics endHole([bool applyToCurrentQueue = false]) {
    _holeMode = false;
    // apply to previous elements.
    if (!_currentDrawing!.isHole) {
      throw "Can't endHole() without starting a beginHole() command.";
    }
    final holePath = _path!;
    holePath.close();
    _currentDrawing = _drawingQueue.last;
    if (!applyToCurrentQueue) {
      _currentDrawing!.path = Path.combine(
        PathOperation.difference,
        _path!,
        holePath,
      );
    } else {
      for (final cmd in _drawingQueue) {
        cmd!.path = Path.combine(
          PathOperation.difference,
          cmd.path!,
          holePath,
        );
      }
    }
    return this;
  }

  /// Returns a list of all bounding boxes of the drawn shapes.
  ///
  /// If [out] is provided, it appends the bounding boxes to the given list
  /// and returns it. Otherwise, it creates a new list.
  ///
  /// Getting all paths bounds is more "accurate" when the object is rotated.
  /// cause it calculates each transformed matrix individually. But it has
  /// a bigger CPU hit.
  ///
  /// In [Graphics] "paths" are separated by [Paint] drawing commands:
  /// [beginFill] and [lineStyle]
  List<GRect> getAllBounds([List<GRect>? out]) {
    out ??= <GRect>[];
    for (var e in _drawingQueue) {
      final pathRect = e?.path?.getBounds();
      if (pathRect == null) {
        break;
      }
      out.add(GRect.fromNative(pathRect));
    }
    return out;
  }

  /// Returns the bounding box of the graphics object.
  ///
  /// If [out] is provided, it sets the bounding box values to the given
  /// [GRect] and returns it. Otherwise, it creates a new [GRect].
  @override
  GRect getBounds([GRect? out]) {
    Rect? r;
    for (var e in _drawingQueue) {
      final pathRect = e?.path?.getBounds();
      if (pathRect == null) {
        break;
      }
      if (r == null) {
        r = pathRect;
      } else {
        r = r.expandToInclude(pathRect);
      }
    }
    final result = r ?? Rect.zero;
    if (out == null) {
      out = GRect.fromNative(result);
    } else {
      out.setTo(result.left, result.top, result.width, result.height);
    }
    return out;
  }

  /// Returns the combined path of all the graphics in the drawing queue.
  ///
  /// The paths are combined using [PathOperation.union]. This method is only
  /// supported on platforms that uses Skia engine.
  Path getPaths() {
    var output = Path();
    if (SystemUtils.usingSkia) {
      for (var graph in _drawingQueue) {
        /// unsupported on web.
        output = Path.combine(PathOperation.union, output, graph!.path!);
      }
    } else {
      trace('Graphics.getPaths() is unsupported in the current platform.');
    }
    return output;
  }

  /// Determines whether the given [localPoint] is within the bounds of this
  /// [Graphics] object.
  ///
  /// If [useShape] is set to `true`, the method will test if the point is
  /// within the shapes drawn by this object, rather than just the bounding box
  /// of those shapes (false by default).
  ///
  /// Returns `true` if the [localPoint] is within the bounds of this [Graphics]
  /// object, `false` otherwise.
  bool hitTest(GPoint localPoint, [bool useShape = false]) {
    if (useShape) {
      final point = Offset(
        localPoint.x,
        localPoint.y,
      );
      for (var e in _drawingQueue) {
        if (e!.path!.contains(point)) {
          return true;
        }
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

  /// Sets the bitmap for drawing strokes.
  /// Use after [lineStyle()] to apply an image shader into the current Paint.
  ///
  /// If [_holeMode] is true, the method will do nothing and return this
  /// [Graphics] object.
  ///
  /// If [matrix] is not specified, the method uses [_helperMatrix].
  ///
  /// If [repeat] is true, the bitmap is tiled to fill the stroke.
  ///
  /// If [smooth] is false, the method applies anti-aliasing to the stroke.
  ///
  /// Returns this [Graphics] object after setting the bitmap for strokes.
  Graphics lineBitmapStyle(
    GTexture texture, [
    GMatrix? matrix,
    bool repeat = true,
    bool smooth = false,
  ]) {
    if (_holeMode) {
      return this;
    }
    assert(_currentDrawing!.fill?.style == PaintingStyle.stroke);
    final fill = _currentDrawing!.fill!;
    fill.isAntiAlias = smooth;
    var tileMode = !repeat ? TileMode.clamp : TileMode.repeated;
    matrix ??= _helperMatrix;
    fill.shader = ImageShader(
      texture.root!,
      tileMode,
      tileMode,
      matrix.toNative().storage,
    );
    return this;
  }

  /// Sets the gradient type for drawing strokes. Uses a gradient shader for the
  /// current [lineStyle], so is mandatory to have a [lineStyle] before calling
  /// this method.
  ///
  /// For [GradientType.linear], [begin] represents the start,
  ///
  /// for [GradientType.radial] and [GradientType.sweep], [begin] represents the
  /// center. Also for [GradientType.radial], [end] represents the
  /// [RadialGradient.focal].
  ///
  /// So make sure to increase the [radius] if you use a [RadialGradient.focal]
  /// alignment different than the center (meaning `begin!=end`).
  ///
  /// If [_holeMode] is true, the method will do nothing and return this
  /// [Graphics] object.
  ///
  /// If [ratios] is not specified, the method creates an equal distribution of
  /// color across the gradient.
  ///
  /// If [begin] is not specified, the method uses [Alignment.center].
  ///
  /// If [end] is not specified, the method uses [Alignment.centerRight].
  ///
  /// If [rotation] is not specified, the method uses `0.0`.
  ///
  /// If [tileMode] is not specified, the method uses [TileMode.clamp].
  ///
  /// If [gradientBox] is specified, the method uses it to create a gradient
  /// shader that matches the bounding box of the object.
  ///
  /// If [radius] is not specified, the method uses `0.5`.
  ///
  /// If [focalRadius] is not specified, the method uses `0.0`.
  ///
  /// If [sweepStartAngle] is not specified, the method uses `0.0`.
  ///
  /// If [sweepEndAngle] is not specified, the method uses 2 pi (full circle).
  ///
  /// Returns this [Graphics] object after setting the gradient type for strokes.
  Graphics lineGradientStyle(
    GradientType type,
    List<Color> colors, {
    List<double>? ratios,
    Alignment? begin,
    Alignment? end,
    double rotation = 0,

    /// only `GradientType.radial`
    double radius = 0.5,
    double focalRadius = 0.0,

    /// only `GradientType.sweep`
    double sweepStartAngle = 0.0,
    double sweepEndAngle = 6.2832,

    /// manually define the bounding box of the Gradient shader.
    Rect? gradientBox,

    /// when the gradient box is different than the object bounds, you can
    /// see the `tileMode` behaviour.
    TileMode tileMode = TileMode.clamp,
  }) {
    /// actual paint must be stroke.
    assert(_currentDrawing!.fill!.style == PaintingStyle.stroke);

    final gradient = _createGradient(
      type,
      colors,
      ratios,
      begin,
      end,
      rotation,
      radius,
      focalRadius,
      sweepStartAngle,
      sweepEndAngle,
      tileMode,
    );
    if (gradientBox != null) {
      _currentDrawing!.fill!.shader = gradient.createShader(gradientBox);
    } else {
      _currentDrawing!.gradient = gradient;
    }
    return this;
  }

  /// Sets the shader for drawing strokes.
  /// Use after [lineStyle] to apply a shader into the current [Paint].
  ///
  /// If [_holeMode] is true, the method will do nothing and return this
  /// [Graphics] object.
  ///
  /// Returns this [Graphics] object after setting the shader for strokes.
  Graphics lineShaderStyle(Shader shader) {
    if (_holeMode) {
      return this;
    }
    assert(_currentDrawing!.fill?.style == PaintingStyle.stroke);
    if (shader is DisplayShader) {
      assert(shader.shader != null);
      shader = shader.shader!;
    }
    _currentDrawing!.fill!.shader = shader;
    return this;
  }

  /// Sets the line style for drawing strokes.
  ///
  /// If [thickness] is not specified, the line thickness is set to `0.0`.
  ///
  /// If [color] is not specified, the line color is set to [kColorBlack].
  ///
  /// If [pixelHinting] is `true`, the method applies anti-aliasing to the
  /// stroke.
  ///
  /// If [caps] is not specified, the method uses [StrokeCap.butt].
  ///
  /// If [joints] is not specified, the method uses [StrokeJoin.miter].
  ///
  /// If [miterLimit] is not specified, the method uses `3.0`.
  ///
  /// Returns this [Graphics] object after setting the line style.
  Graphics lineStyle([
    double thickness = 0.0,
    Color color = kColorBlack,
    bool pixelHinting = true,
    StrokeCap? caps,
    StrokeJoin? joints,
    double miterLimit = 3.0,
  ]) {
    alpha = alpha.clamp(0.0, 1.0);
    final paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = color;
    paint.strokeWidth = thickness;
    paint.isAntiAlias = pixelHinting;
    paint.strokeCap = caps ?? StrokeCap.butt;
    paint.strokeJoin = joints ?? StrokeJoin.miter;
    if (SystemUtils.usingSkia) {
      paint.strokeMiterLimit = miterLimit;
    }
    _addFill(paint);
    return this;
  }

  /// Draws a straight line from the current drawing position to the specified
  /// coordinates using a line segment.
  ///
  /// This method adds a line segment to the current path. The line starts from
  /// the last point in the path, and ends at the specified point ([x], [y]).
  ///
  /// The method returns this, which allows for method chaining.
  Graphics lineTo(double x, double y) {
    _path!.lineTo(x, y);
    return this;
  }

  /// Moves the current drawing position to the specified [x] and [y]
  /// coordinates.
  ///
  /// The method returns this, which allows for method chaining.
  Graphics moveTo(double x, double y) {
    _path!.moveTo(x, y);
    return this;
  }

  /// (Internal usage)
  /// Paints the graphics onto the given [Canvas].
  /// If [isMask] is true, it clips the canvas to the path of each [GraphicsDrawingData]
  /// in the _drawingQueue, allowing for masking effects.
  /// Otherwise, it iterates over each [GraphicsDrawingData] in the _drawingQueue and
  /// draws its path or picture onto the canvas, filling it with the corresponding Paint.
  /// If the [GraphicsDrawingData] contains a gradient, it calculates the gradient's bounds
  /// and creates a shader from the gradient to fill the shape.
  /// If the [GraphicsDrawingData] contains vertices, it draws them onto the canvas using
  /// the corresponding Paint.
  /// If the [GraphicsDrawingData] contains a picture, it draws the picture onto the canvas.
  @override
  void paint(Canvas canvas) {
    // TODO : add mask support.
    if (isMask) {
      for (var graph in _drawingQueue) {
        canvas.clipPath(graph!.path!, doAntiAlias: false);
      }
      return;
    }
    _constrainAlpha();
    if (!_isVisible) return;

    for (var graph in _drawingQueue) {
      if (graph!.hasPicture) {
        canvas.drawPicture(graph.picture!);
        break;
      }
      final fill = graph.fill!;
      final baseColor = fill.color;
      // FIX: causes flickering on rendering.
      // if (baseColor.alpha == 0) break;

      /// calculate gradient.
      if (graph.hasGradient) {
        Rect? graphBounds;
        if (graph.hasVertices) {
          graphBounds = graph.vertices!.getBounds();
        } else {
          graphBounds = graph.path!.getBounds();
        }

        /// TODO: try if this works to change the gradient
        /// opacity from the Shape.
        fill.color = baseColor.withOpacity(alpha);
        fill.shader = graph.gradient!.createShader(graphBounds!);
      } else {
        if (alpha != 1) {
          fill.color = baseColor.withOpacity(baseColor.opacity * alpha);
        }
      }
      if (graph.hasVertices) {
        if (graph.vertices!.uvtData != null && graph.shaderTexture != null) {
          graph.vertices!.calculateUvt(graph.shaderTexture);
        }
        if (fill.style == PaintingStyle.stroke) {
          canvas.drawRawPoints(
            ui.PointMode.lines,
            graph.vertices!.rawPoints!,
            fill,
          );
        } else {
          canvas.drawVertices(
            graph.vertices!.rawData!,
            graph.vertices!.blendMode!,
            fill,
          );
        }
      } else {
        canvas.drawPath(graph.path!, fill);
      }

      fill.color = baseColor;
    }
  }

  /// Paints the graphics with the specified [fill] on the given [canvas].
  ///
  /// If the graphics contains a picture, it will be drawn instead of the path.
  /// Otherwise, the path will be filled with the provided [fill] paint. This
  /// method skips drawing if the graphics is not visible.
  void paintWithFill(Canvas canvas, Paint fill) {
    if (!_isVisible) {
      return;
    }
    for (var graph in _drawingQueue) {
      if (graph!.hasPicture) {
        canvas.drawPicture(graph.picture!);
        return;
      }
      canvas.drawPath(graph.path!, fill);
    }
  }

  /// Removes the last [GraphicsDrawingData] from the drawing queue.
  /// This should be used only if you are operating with [Path] and [Paint]
  /// directly.
  GraphicsDrawingData? popData() {
    return _drawingQueue.removeLast();
  }

  /// Push a [GraphicsDrawingData] into the commands list.
  /// This way you can use the low level APIs as you please.
  /// When set [asCurrent] to `true`, it will be used as the current
  /// [GraphicsDrawingData] and you can keep modifying the internal path
  /// with [Graphics] commands.
  /// This should be used only if you are operating with [Path] and [Paint]
  /// directly.
  /// [x] and [y] can shift the [Path] coordinates.
  void pushData(
    GraphicsDrawingData data, [
    bool asCurrent = false,
    double? x,
    double? y,
  ]) {
    if (x != null && y != null && data.path != null) {
      data.path = data.path!.shift(Offset(x, y));
    }
    _drawingQueue.add(data);
    if (asCurrent) {
      _currentDrawing = data;
    }
  }

  /// Removes, if enqueued, the specified [GraphicsDrawingData] instance from
  /// the drawing queue list. This should be used only if you are operating with
  /// [Path] and [Paint] directly.
  void removeData(GraphicsDrawingData data) {
    _drawingQueue.remove(data);
  }

  /// Shifts the current path by a given offset [x], [y].
  ///
  /// If [modifyPreviousPaths] is true, all previous paths will also be shifted
  /// by the same offset.
  void shiftPath(double x, double y, [bool modifyPreviousPaths = false]) {
    final offset = Offset(x, y);
    if (modifyPreviousPaths) {
      for (var command in _drawingQueue) {
        command?.path = command.path?.shift(offset);
      }
    } else {
      _currentDrawing?.path = _currentDrawing?.path?.shift(offset);
    }
  }

  /// Adds the provided [fill] to the drawing queue.
  ///
  /// If the [fill] has the same type as the previous drawing, it is added to
  /// the existing path. Otherwise, a new drawing data is created with an empty
  /// path and added to the drawing queue.
  void _addFill(Paint fill) {
    /// same type, create path.
    Path? path;
    if (_currentDrawing!.isSameType(fill)) {
      path = Path();
    } else {
      path = _currentDrawing?.path;
    }
    _currentDrawing = GraphicsDrawingData(fill, path);
    _drawingQueue.add(_currentDrawing);
  }

  /// Clamps the [alpha] value to the range of 0.0 to 1.0 to ensure that it is a
  /// valid opacity value.
  void _constrainAlpha() {
    alpha = alpha.clamp(0.0, 1.0);
  }

  /// Creates a Flutter `Gradient` object based on the specified parameters.
  ///
  /// The gradient type can be [GradientType.linear], [GradientType.radial], or
  /// [GradientType.sweep], which determine the type of gradient to create.
  ///
  /// For a radial gradient, the [radius] parameter specifies the radius of the
  /// circle, and the [focalRadius] parameter specifies the radius of the focal
  /// point. For a sweep gradient, the [sweepStartAngle] and [sweepEndAngle]
  /// parameters specify the starting and ending angles of the arc,
  /// respectively.
  ///
  /// The [ratios] parameter is a list of values that determines the relative
  /// position of each color stop in the gradient.
  ///
  /// The [begin] and [end] parameters specify the start and end points of the
  /// gradient, respectively. For a linear gradient, they are `Alignment`
  /// objects, and for a radial gradient, they are `Alignment` objects relative
  /// to the center of the circle.
  ///
  /// The [tileMode] parameter determines how the gradient should be repeated if
  /// it extends beyond its bounds.
  ///
  /// The [rotation] parameter specifies the rotation of the gradient in
  /// degrees.
  ///
  /// Returns a [Gradient] object created using the specified parameters.
  Gradient _createGradient(
    GradientType type,
    List<Color> colors, [
    List<double>? ratios,
    Alignment? begin,
    Alignment? end,
    double rotation = 0,

    /// only radial
    double radius = 0.5,
    double focalRadius = 0.0,

    /// only sweep
    double sweepStartAngle = 0.0,
    double sweepEndAngle = 6.2832,
    TileMode tileMode = TileMode.clamp,
  ]) {
    final transform = GradientRotation(rotation);
    if (type == GradientType.radial) {
      return RadialGradient(
        center: begin ?? Alignment.center,
        focal: end,
        radius: radius,
        colors: colors,
        stops: ratios,
        tileMode: tileMode,
        focalRadius: focalRadius,
        transform: transform,
      );
    } else if (type == GradientType.sweep) {
      return SweepGradient(
        center: begin ?? Alignment.center,
        colors: colors,
        stops: ratios,
        tileMode: tileMode,
        transform: transform,
        startAngle: sweepStartAngle,
        endAngle: sweepEndAngle,
      );
    }
    return LinearGradient(
      colors: colors,
      stops: ratios,
      begin: begin ?? Alignment.centerLeft,
      end: end ?? Alignment.centerRight,
      tileMode: tileMode,
      transform: transform,
    );
  }

  /// (Internal usage)
  /// Updates the stage rectangle path with the given [rect].
  static void updateStageRect(GRect rect) {
    stageRectPath.reset();
    stageRectPath.addRect(rect.toNative());
  }
}

/// Data class that holds information about a graphic element's drawing data.
class GraphicsDrawingData {
  /// The path of the element.
  Path? path;

  /// The paint to be applied to the element.
  Paint? fill;

  /// The gradient applied to the element.
  Gradient? gradient;

  /// The picture applied to the element.
  ui.Picture? picture;

  /// Flag that indicates if the element is a hole or not.
  bool isHole = false;

  /// The blend mode applied to the element, used for drawVertices().
  BlendMode blendMode = BlendMode.src;

  /// The vertices data of the element.
  GraphicsVertices? vertices;

  /// The texture to be used in the image shader, if any.
  /// For [Graphics.beginBitmapFill] and [Graphics.beginShader].
  GTexture? shaderTexture;

  /// Creates a new instance of [GraphicsDrawingData] with the given [fill] and
  /// [path].
  GraphicsDrawingData([this.fill, this.path]);

  /// Returns a boolean value indicating if the element has a gradient.
  bool get hasGradient => gradient != null;

  /// Returns a boolean value indicating if the element has a picture.
  bool get hasPicture => picture != null;

  /// Returns a boolean value indicating if the element has vertices.
  bool get hasVertices => vertices != null;

  /// Creates a new instance of [GraphicsDrawingData] from the current instance.
  /// When cloning, we can pass fill and path by reference or make a deep copy.
  /// Mostly intended for direct `Graphics.pushData` and `Graphics.removeData`
  /// manipulation.
  GraphicsDrawingData clone([
    bool cloneFill = false,
    bool clonePath = false,
  ]) {
    final newFill = cloneFill ? fill?.clone() : fill;
    final newPath = clonePath ? (path != null ? Path.from(path!) : null) : path;
    final newVertices = vertices;
    return GraphicsDrawingData(newFill, newPath)
      ..gradient = gradient
      ..picture = picture
      ..blendMode = blendMode
      ..vertices = newVertices;
  }

  /// Returns a boolean value indicating if the provided paint is of the same
  /// type as the [fill] of this instance.
  bool isSameType(Paint otherFill) {
    return fill?.style == otherFill.style;
  }
}
