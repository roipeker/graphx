import 'dart:math';
import 'dart:ui';

import 'package:flutter/painting.dart';
import 'package:graphx/graphx/geom/gxrect.dart';
import 'package:graphx/graphx/textures/base_texture.dart';
import 'package:graphx/graphx/utils/interfases.dart';
import 'package:graphx/graphx/utils/mixins.dart';

class Graphics with RenderUtilMixin implements GxRenderable {
//  Path _path = Path();
  final _commands = <_GraphicsDataModel>[];
  _GraphicsDataModel _currentDrawing = _GraphicsDataModel(null, Path());
  double alpha = 1;

  Graphics mask;

  Path get _path => _currentDrawing.path;

  void dispose() {
    mask = null;
    _commands?.clear();
    _currentDrawing = null;
  }

  GxRect getBounds() {
    Rect r;
    _commands.forEach((e) {
      final pathRect = e?.path?.getBounds();
      if (pathRect == null) return;
      if (r == null) {
        r = pathRect;
      } else {
        r = r.expandToInclude(pathRect);
      }
    });
    return GxRect.fromNative(r ?? Rect.zero);
  }

  bool hitTest(double x, double y, [bool useShape = false]) {
    final point = Offset(x, y);
    if (useShape) {
      for (var e in _commands) {
        if (e.path.contains(point)) return true;
      }
      return false;
    } else {
//      return getBounds().contains(Offset(x, y));
      return getBounds().contains(x, y);
    }
  }

  void clear() {
    _commands.clear();
    _currentDrawing = _GraphicsDataModel(null, Path());
  }

  void beginFill(int color, [double alpha = 1]) {
    final fill = Paint();
    fill.style = PaintingStyle.fill;
    fill.isAntiAlias = true;
    fill.color = Color(color).withOpacity(alpha);
    _addFill(fill);
  }

  void drawPicture(Picture picture) {
    _commands.add(_GraphicsDataModel()..picture = picture);
  }

  void drawImage(Image img) {}

  void endFill() {
    _currentDrawing = _GraphicsDataModel(null, Path());
  }

  void lineStyle([
    double thickness = 0,
    int color,
    double alpha = 1,
    bool pixelHinting = true,
    StrokeCap caps,
    StrokeJoin joints,
    double miterLimit = 3.0,
  ]) {
    final paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = Color(color).withOpacity(alpha);
    paint.strokeWidth = thickness;
    paint.isAntiAlias = pixelHinting;
    paint.strokeCap = caps ?? StrokeCap.butt;
    paint.strokeJoin = joints ?? StrokeJoin.miter;
    paint.strokeMiterLimit = miterLimit;
    _addFill(paint);
  }

  beginGradientFill(
    List<int> colors, [
    List<double> alphas,
    List<double> ratios,
    Alignment begin,
    Alignment end,
    GradientTransform transform,
    Rect gradientBox,
  ]) {
    final _colors = _GraphUtils.colorsFromHex(colors, alphas);
    final gradient = LinearGradient(
      colors: _colors,
      stops: ratios,
      begin: begin ?? Alignment.topLeft,
      end: end ?? Alignment.topRight,
      tileMode: TileMode.clamp,
      transform: transform,
    );
    final paint = Paint();
    paint.style = PaintingStyle.fill;
//    paint.isAntiAlias = true;
    _addFill(paint);
    if (gradientBox != null) {
      _currentDrawing.fill.shader = gradient.createShader(gradientBox);
    } else {
      _currentDrawing.grad = gradient;
    }
  }

  lineGradientStyle(
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
      _currentDrawing.grad = gradient;
    }
  }

  void moveTo(double x, double y) {
    _path.moveTo(x, y);
  }

  void lineTo(double x, double y) {
    _path.lineTo(x, y);
  }

  void cubicCurveTo(double controlX1, double controlY1, double controlX2,
      double controlY2, double anchorX, double anchorY) {
    _path.cubicTo(controlX1, controlY1, controlX2, controlY2, anchorX, anchorY);
  }

  void curveTo(
      double controlX, double controlY, double anchorX, double anchorY) {
    _path.quadraticBezierTo(controlX, controlY, anchorX, anchorY);
  }

  void drawCircle(double x, double y, double radius) {
    final pos = Offset(x, y);
    final circ = Rect.fromCircle(center: pos, radius: radius);
    _path.addOval(circ);
  }

  void drawRect(double x, double y, double width, double height) {
    final r = Rect.fromLTWH(x, y, width, height);
    _path.addRect(r);
  }

  void drawRoundRect(
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
  }

  void drawPolygon(
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
  }

  void drawStar(
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
    final polys = List<Offset>();
    for (var i = 0; i < len; ++i) {
      final r = i.isOdd ? innerRadius : radius;
      final a = i * delta + startAngle;
      polys.add(Offset(
        x + (r * cos(a)),
        y + (r * sin(a)),
      ));
    }
    _path.addPolygon(polys, true);
  }

  void paint(Canvas canvas) {
    _constrainAlpha();
    if (!_isVisible) return;
    _commands.forEach((graph) {
      if (graph.hasPicture) {
        canvas.drawPicture(graph.picture);
        return;
      }
      final fill = graph.fill;
      final baseColor = fill.color;
      if (baseColor.alpha == 0) return;

      /// calculate gradient.
      if (graph.hasGrad) {
        final _bounds = graph.path.getBounds();
        fill.shader = graph.grad.createShader(_bounds);
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
    _currentDrawing = _GraphicsDataModel(fill, _currentDrawing?.path ?? Path());
    _commands.add(_currentDrawing);
  }

  bool get _isVisible => alpha > 0 || _commands.isEmpty;

  void _constrainAlpha() {
    alpha = alpha.clamp(0.0, 1.0);
  }
}

class _GraphicsDataModel {
  Path path;
  Paint fill;
  Gradient grad;
  Picture picture;

  _GraphicsDataModel([this.fill, this.path]);

  get hasPicture => picture != null;

  get hasGrad => grad != null;

// compute grad?
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
