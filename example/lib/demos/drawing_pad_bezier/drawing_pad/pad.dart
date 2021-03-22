import 'package:flutter/material.dart';
import 'package:graphx/graphx.dart';

import 'bezier.dart';
import 'point.dart';

class Pad extends GSprite {
  double velocityFilterWeight = 0.7;
  double minW = .5;
  double maxW = 2.5;
  int throttle = 16; // ms
  double minDist = 5;

  double get dotSize => (minW + maxW) / 2;

  Color penColor = Color(0xff000000);
  Color backgroundColor = Colors.black;
  Function? onBegin, onEnd, onUpdate;
  final List<PadPoint> _lastPoints = [];
  double _lastVelocity = 0;
  double _lastWidth = 0;
  GShape? _canvas;

  late GShape _bg;

  GShape? get canvas => _canvas;
  late Graphics _g;
  double w, h;

  Pad({this.w = 300, this.h = 200}) {
    _canvas = GShape();
    _bg = GShape();
    addChild(_bg);
    addChild(_canvas!);
    _g = _canvas!.graphics;
    clear();
    on();
  }

  List<_StrokeData> _data = <_StrokeData>[];
  bool _isEmpty = true;
  bool _isMouseDown = false;

  bool get isEmpty => _isEmpty;
  Color baseTransparent = Colors.black.withOpacity(.01);

  void clear() {
    _g.clear();
    _bg.graphics
        .clear()
        .beginFill(backgroundColor)
        .drawRect(0, 0, w, h)
        .endFill();
    _g.clear().beginFill(baseTransparent).drawRect(0, 0, w, h).endFill();
    _data.clear();
    _reset();
    _isEmpty = true;
  }

  void resize(double sw, double sh) {
    w = sw;
    h = sh;
    clear();
  }

  void _reset() {
    _lastPoints.clear();
    _lastVelocity = 0;
    _lastWidth = (minW + maxW) / 2;
  }

  void off() {
    onMouseDown.remove(_handleMouseDown);
    onMouseMove.remove(_handleMouseMove);
    stage?.onMouseUp.remove(_handleMouseUp);
  }

  void on() {
    onMouseDown.add(_handleMouseDown);
    onMouseMove.add(_handleMouseMove);
  }

  _handleMouseDown(MouseInputData input) {
    stage!.onMouseUp.addOnce(_handleMouseUp);
    _isMouseDown = true;
    _strokeBegin(input);
  }

  _handleMouseUp(MouseInputData input) {
    _isMouseDown = false;
    _strokeEnd(input);
  }

  _handleMouseMove(MouseInputData input) {
    if (_isMouseDown) {
      _strokeMove(input);
    }
  }

  void _strokeMove(input) {
    /// use throttle update.
    _strokeUpdate(input);
  }

  void _strokeEnd(MouseInputData input) {
    _strokeUpdate(input);
    onEnd?.call();
  }

  void _strokeBegin(MouseInputData input) {
    var pointGroup = _StrokeData(penColor);
    onBegin?.call();
    _data.add(pointGroup);
    _reset();
    _strokeUpdate(input);
  }

  void _strokeUpdate(MouseInputData input) {
    if (_data.isEmpty) {
      _strokeBegin(input);
      return;
    }

    final mx = _canvas!.mouseX;
    final my = _canvas!.mouseY;
    final point = _createPoint(mx, my);
    final lastPointData = _data.last;
    var lastPoints = lastPointData.points;
    var lastPoint = lastPoints.isNotEmpty ? lastPoints.last : null;
    var hasLastPoint = lastPoint != null;
    var isLastPointTooClose =
        hasLastPoint ? point.distanceTo(lastPoint!) <= minDist : false;
    final color = lastPointData.color;

    if (!hasLastPoint || !(hasLastPoint && isLastPointTooClose)) {
      var curve = _addPoint(point);
      if (!hasLastPoint) {
        _drawDot(color, point);
      } else if (curve != null) {
        _drawCurve(color, curve);
      }
      lastPoints.add(PadPoint(point.x, point.y, point.time));
    }
    onUpdate?.call();
  }

  PadPoint _createPoint(double px, double py) => PadPoint(px, py, getTimer());

  BezierDraw? _addPoint(PadPoint point) {
    _lastPoints.add(point);
    if (_lastPoints.length > 2) {
      if (_lastPoints.length == 3) {
        _lastPoints.insert(0, _lastPoints.first);
      }
      final widths = _calculateCurveWidths(_lastPoints[1], _lastPoints[2]);
      var curve = BezierDraw.fromPoints(_lastPoints, widths[0], widths[1]);
      _lastPoints.removeAt(0);
      return curve;
    }
    return null;
  }

  List<double> _calculateCurveWidths(PadPoint p1, PadPoint p2) {
    var vel = velocityFilterWeight * p2.velocityForm(p1) +
        (1 - velocityFilterWeight) * _lastVelocity;

    var newW = _strokeWidth(vel);
    final widths = [
      _lastWidth,
      newW,
    ];
    _lastVelocity = vel;
    _lastWidth = newW;
    return widths;
  }

  double _strokeWidth(double vel) {
    return Math.max(maxW / (vel + 1), minW);
  }

  void _drawCurveSegment(double x, double y, double w) {
    _g.moveTo(x, y);
    _g.drawCircle(x, y, w);
    _isEmpty = false;
  }

  double getDotSize() {
    return dotSize;
  }

  void _drawDot(Color color, PadPoint point) {
    var w = getDotSize();
    _g.beginFill(color);
    _drawCurveSegment(point.x, point.y, w);
    _g.endFill();
  }

  void _drawCurve(Color color, BezierDraw curve) {
    var wd = curve.endW - curve.startW;
    int drawSteps = curve.length().floor() * 2;

    _g.beginFill(color);
    for (var i = 0; i < drawSteps; ++i) {
      var t = i / drawSteps;
      var tt = t * t;
      var ttt = tt * t;
      var u = 1 - t;
      var uu = u * u;
      var uuu = uu * u;

      var x = uuu * curve.startPoint.x;
      x += 3 * uu * t * curve.control1.x;
      x += 3 * u * tt * curve.control2.x;
      x += ttt * curve.endPoint.x;

      var y = uuu * curve.startPoint.y;
      y += 3 * uu * t * curve.control1.y;
      y += 3 * u * tt * curve.control2.y;
      y += ttt * curve.endPoint.y;

      var w = Math.min(curve.startW + ttt * wd, maxW);
      _drawCurveSegment(x, y, w);
    }
    _g.endFill();
  }
}

class _StrokeData {
  Color color;
  late List<PadPoint> points;

  _StrokeData(this.color) {
    points = [];
  }
}
